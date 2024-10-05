//
//  StandardStoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This class implements the ``StoreService`` protocol, and
/// can be used to integrate with StoreKit.
///
/// This service keeps products and purchases in sync, using
/// the provided ``StoreContext`` and can be used by SwiftUI
/// based apps, to observe context changes.
///
/// You can use this service with a local product collection,
/// by adding a StoreKit configuration file to the app.
open class StandardStoreService: StoreService {

    /// Create a service instance for the provided IDs.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to handle.
    public init(
        productIds: [String]
    ) {
        self.productIds = productIds
        updateTransactionsOnLaunch()
    }

    /// Create a service instance for the provided `products`,
    /// that syncs any changes to the provided `context`.
    ///
    /// - Parameters:
    ///   - products: The products to handle.
    public convenience init<Product: ProductRepresentable>(
        products: [Product]
    ) {
        self.init(
            productIds: products.map { $0.id }
        )
    }
    
    private let productIds: [String]
    
    open func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }

    open func purchase(_ product: Product) async throws -> Product.PurchaseResult {
        #if os(visionOS)
        throw StoreServiceError.unsupportedPlatform("This purchase operation is not supported in visionOS: Use @Environment(\\.purchase) instead.")
        #else
        let result = try await product.purchase()
        switch result {
        case .success(let result): try await finalizePurchaseResult(result)
        case .pending: break
        case .userCancelled: break
        @unknown default: break
        }
        return result
        #endif
    }
    
    @discardableResult
    open func restorePurchases() async throws -> [Transaction] {
        var transactions: [Transaction] = []
        for id in productIds {
            if let transaction = try await getValidTransaction(for: id) {
                transactions.append(transaction)
            }
        }
        return transactions
    }

    open func syncStoreData(to context: StoreContext) async throws {
        let products = try await getProducts()
        await context.updateProducts(products)
        try await restorePurchases()
    }


    // MARK: - Open functions

    /// Finalize a purchase result from a ``purchase(_:)``.
    open func finalizePurchaseResult(
        _ result: VerificationResult<Transaction>
    ) async throws {
        let transaction = try result.verify()
        await transaction.finish()
    }

    /// Try to resolve a valid transaction for a certain ID.
    ///
    /// This function will fetch and verify all transactions
    /// before returning them.
    open func getValidTransaction(
        for productId: ProductID
    ) async throws -> Transaction? {
        guard let latest = await Transaction.latest(for: productId) else { return nil }
        let result = try latest.verify()
        return result.isValid ? result : nil
    }

    /// This function is called by the initializer, and will
    /// fetch transaction updates and try to verify them.
    open func updateTransactionsOnLaunch() {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    try result.verify()
                } catch {
                    print("Transaction listener error: \(error)")
                }
            }
        }
    }
}

private extension VerificationResult where SignedType == Transaction {

    @discardableResult
    func verify() throws -> Transaction {
        switch self {
        case .unverified(let transaction, let error): throw StoreServiceError.invalidTransaction(transaction, error)
        case .verified(let transaction): return transaction
        }
    }
}
