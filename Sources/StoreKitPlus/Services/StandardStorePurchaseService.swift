//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This service class can be used to perform StoreKit purchase
 operations and restore previous purchases.

 The service keeps purchases in sync, using a ``StoreContext``.
 This can be used to observe context changes to drive the UI.
 */
open class StandardStorePurchaseService: StorePurchaseService {

    /**
     Create a service instance for the provided `productIds`,
     that syncs transactions to the provided `context`.

     - Parameters:
       - productIds: The IDs of the products to fetch.
     - context: The store context to sync with.
     */
    public init(
        productIds: [String],
        context: StoreContext = StoreContext()
    ) {
        self.productIds = productIds
        self.context = context
        self.transactionTask = nil
        self.transactionTask = getTransactionListenerTask()
    }

    deinit {
        self.transactionTask = nil
    }

    private let productIds: [String]
    private let context: StoreContext
    private var transactionTask: Task<Void, Error>?

    /**
     Purchase a certain product.

     - Parameters:
       - product: The product to purchase.
    */
   open func purchase(_ product: Product) async throws -> Product.PurchaseResult {
       let result = try await product.purchase()
       switch result {
       case .success(let result): try await handleTransaction(result)
       case .pending: break
       case .userCancelled: break
       @unknown default: break
       }
       return result
   }

    /**
     Restore purchases that are not on this device.
     */
    open func restorePurchases() async throws {
        try await syncTransactions()
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
private extension StandardStorePurchaseService {

    /**
     Create a task that can be used to listen for and acting
     on transaction changes.
     */
    func getTransactionListenerTask() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    try await self.handleTransaction(result)
                } catch {
                    print("Transaction listener error: \(error)")
                }
            }
        }
    }

    /**
     Try resolving a valid transaction for a certain product.
     */
    func getValidTransaction(for productId: String) async throws -> Transaction? {
        guard let latest = await Transaction.latest(for: productId) else { return nil }
        let result = try verifyTransaction(latest)
        return result.isValid ? result : nil
    }

    /**
     Handle the transaction in the provided result.
     */
    func handleTransaction(_ result: VerificationResult<Transaction>) async throws {
        let transaction = try verifyTransaction(result)
        await updateContext(with: transaction)
        await transaction.finish()
    }

    /**
     Sync the transactions of all available products.
     */
    func syncTransactions() async throws {
        var transactions: [Transaction] = []
        for id in productIds {
            if let transaction = try await getValidTransaction(for: id) {
                transactions.append(transaction)
            }
        }
        await updateContext(with: transactions)
    }

    /**
     Verify the transaction in the provided `result`
     */
    func verifyTransaction(_ result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .unverified(let transaction, let error): throw StoreServiceError.invalidTransaction(transaction, error)
        case .verified(let transaction): return transaction
        }
    }
}

@MainActor
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
private extension StandardStorePurchaseService {

    func updateContext(with transaction: Transaction) {
        var transactions = context.purchaseTransactions
            .filter { $0.productID != transaction.productID }
        transactions.append(transaction)
        context.purchaseTransactions = transactions
    }

    func updateContext(with transactions: [Transaction]) {
        context.purchaseTransactions = transactions
    }
}
