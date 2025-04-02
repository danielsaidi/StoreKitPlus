//
//  StandardStoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

public extension StoreService where Self == StandardStoreService {

    /// Create a service instance for the provided IDs.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to handle.
    static func standard(
        productIds: [String]
    ) -> Self {
        .init(productIds: productIds)
    }

    /// Create a service instance for the provided products.
    ///
    /// - Parameters:
    ///   - products: The products to handle.
    static func standard<Product: ProductRepresentable>(
        products: [Product]
    ) -> Self {
        .init(products: products)
    }
}

/// This class implements the ``StoreService`` protocol, and
/// can be used to integrate with StoreKit.
///
/// You can use this service with a local product collection,
/// by adding a StoreKit configuration file to the app.
///
/// You can use the two ``StoreService/standard(products:)``
/// shorthands to easily create a standard service instance.
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

    /// Create a service instance for the provided products.
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
    
    @discardableResult
    open func purchase(
        _ product: Product
    ) async throws -> (Product.PurchaseResult, Transaction?) {
        try await purchase(product, options: [])
    }

    @discardableResult
    open func purchase(
        _ product: Product,
        options: Set<Product.PurchaseOption>
    ) async throws -> (Product.PurchaseResult, Transaction?) {
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
        return (result, nil)
        #endif
    }
    
    open func getValidProductTransations() async throws -> [Transaction] {
        var transactions: [Transaction] = []
        for id in productIds {
            if let transaction = try await getValidTransaction(for: id) {
                transactions.append(transaction)
            }
        }
        return transactions
    }

    open func syncStoreData(
        to context: StoreContext
    ) async throws {
        let products = try await getProducts()
        await context.updateProducts(products)
        try await restorePurchases(with: context)
    }


    // MARK: - Open functions

    /// Finalize a purchase result from a ``purchase(_:)``.
    open func finalizePurchaseResult(
        _ result: VerificationResult<Transaction>
    ) async throws {
        let transaction = try result.verify()
        await transaction.finish()
    }
    
    /// Get all valid transations for a certain product.
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
