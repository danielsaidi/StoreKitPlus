//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This class can be used to perform StoreKit purchases.
///
/// This class keeps purchases in sync with a ``StoreContext``
/// that can also be used to observe changes to drive the UI.
open class StandardStorePurchaseService: StorePurchaseService {

    /// Create a service instance for the provided IDs, that
    /// syncs transactions to the provided `context`.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to fetch.
    ///   - context: The store context to sync with.
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

    open func purchase(
        _ product: Product
    ) async throws -> Product.PurchaseResult {
        #if os(visionOS)
        throw StoreServiceError.unsupportedPlatform("This purchase operation is not supported in visionOS: Use @Environment(\\.purchase) instead.")
        #else
        let result = try await product.purchase()
        switch result {
        case .success(let result): try await handleTransaction(result)
        case .pending: break
        case .userCancelled: break
        @unknown default: break
        }
        return result
        #endif
    }
    
    open func restorePurchases() async throws {
        try await syncTransactions()
    }
}

private extension StandardStorePurchaseService {

    /// Get a task that can to listen to transaction changes.
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

    /// Try to resolve a valid transaction for a certain ID.
    func getValidTransaction(for productId: ProductID) async throws -> Transaction? {
        guard let latest = await Transaction.latest(for: productId) else { return nil }
        let result = try verifyTransaction(latest)
        return result.isValid ? result : nil
    }

    /// Handle the transaction in the provided result.
    func handleTransaction(_ result: VerificationResult<Transaction>) async throws {
        let transaction = try verifyTransaction(result)
        await updateContext(with: transaction)
        await transaction.finish()
    }

    /// Sync the transactions of all available products.
    func syncTransactions() async throws {
        var transactions: [Transaction] = []
        for id in productIds {
            if let transaction = try await getValidTransaction(for: id) {
                transactions.append(transaction)
            }
        }
        await updateContext(with: transactions)
    }

    /// Verify the transaction in the provided `result`.
    func verifyTransaction(_ result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .unverified(let transaction, let error): throw StoreServiceError.invalidTransaction(transaction, error)
        case .verified(let transaction): return transaction
        }
    }
}

@MainActor
private extension StandardStorePurchaseService {

    func updateContext(with transaction: Transaction) {
        var transactions = context.purchaseTransactions
            .filter { $0.productID != transaction.productID }
        transactions.append(transaction)
        updateContext(with: transactions)
    }

    func updateContext(with transactions: [Transaction]) {
        DispatchQueue.main.async {
            self.context.purchaseTransactions = transactions
        }
    }
}
