//
//  StandardStoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This service class implements the ``StoreService`` protocol
 by integrating with StoreKit 2.
 
 The service keeps products and purchases in sync, using the
 provided ``StoreContext``. This can be used by e.g. SwiftUI
 apps, to observe context changes to drive the UI.
 
 You can configure your app to use this service with a local
 product collection, by adding a StoreKit configuration file
 to the app.
 */
public class StandardStoreService: StoreService {
    
    /**
     Create a service instance for the provided `productIds`,
     that syncs any changes to the provided `context`.
     
     - Parameters:
       - productIds: The IDs of the products to handle.
       - context: The store context to sync with.
     */
    public init(
        productIds: [String],
        context: StoreContext = StoreContext()) {
        self.productIds = productIds
        self.storeContext = context
        self.transactionTask = nil
        self.transactionTask = getTransactionListenerTask()
    }
    
    deinit {
        self.transactionTask = nil
    }
    
    private let productIds: [String]
    private let storeContext: StoreContext
    private var transactionTask: Task<Void, Error>?
    
    /**
     Get all available products.
     */
    public func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }
    
    /**
     Purchase a certain product.
     */
    public func purchase(_ product: Product) async throws -> Product.PurchaseResult {
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
    public func restorePurchases() async throws {
        try await syncTransactions()
    }

    /**
     Sync product and purchase information from the store to
     the provided store context.
     */
    public func syncStoreData() async throws {
        let products = try await getProducts()
        await updateContext(with: products)
        try await restorePurchases()
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
private extension StandardStoreService {
    
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
     Handle the transaction in the provided `result`.
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
private extension StandardStoreService {
    
    func updateContext(with products: [Product]) {
        storeContext.products = products
    }
    
    func updateContext(with transaction: Transaction) {
        var transactions = storeContext.purchaseTransactions
            .filter { $0.productID != transaction.productID }
        transactions.append(transaction)
        storeContext.purchaseTransactions = transactions
    }
    
    func updateContext(with transactions: [Transaction]) {
        storeContext.purchaseTransactions = transactions
    }
}
