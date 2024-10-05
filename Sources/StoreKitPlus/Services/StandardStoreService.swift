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
    ///   - productService: A custom product service to use, if any.
    ///   - purchaseService: A custom purchase service to use, if any.
    public init(
        productIds: [String],
        purchaseService: StorePurchaseService? = nil
    ) {
        self.productIds = productIds
        self.purchaseService = purchaseService ?? StandardStorePurchaseService(
            productIds: productIds)
    }

    /// Create a service instance for the provided `products`,
    /// that syncs any changes to the provided `context`.
    ///
    /// - Parameters:
    ///   - products: The products to handle.
    ///   - purchaseService: A custom purchase service to use, if any.
    public convenience init<Product: ProductRepresentable>(
        products: [Product],
        purchaseService: StorePurchaseService? = nil
    ) {
        self.init(
            productIds: products.map { $0.id },
            purchaseService: purchaseService
        )
    }
    
    private let productIds: [String]
    private let purchaseService: StorePurchaseService
    
    open func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }

    open func purchase(_ product: Product) async throws -> Product.PurchaseResult {
        try await purchaseService.purchase(product)
    }
    
    @discardableResult
    open func restorePurchases() async throws -> [Transaction] {
        try await purchaseService.restorePurchases()
    }

    open func syncStoreData(to context: StoreContext) async throws {
        let products = try await getProducts()
        await context.updateProducts(products)
        try await restorePurchases()
    }
}
