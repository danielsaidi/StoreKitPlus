//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2026 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol can be implemented by types that can fetch
/// product information, purchase products, restore purchase
/// information, etc.
///
/// Although these operations can be performed with StoreKit
/// APIs, like `Product.products(for:)` to fetch products, a
/// store service can be used as a layer between the app and
/// StoreKit, and can be used to customize or mock the store
/// integration, e.g. in tests.
public protocol StoreService {

    /// Get all available products.
    func getProducts() async throws -> [Product]
    
    /// Get all valid product transations.
    func getValidProductTransations() async throws -> [Transaction]

    /// Purchase a certain product.
    ///
    /// - Parameters:
    ///   - product: The product to purchase.
    @discardableResult
    func purchase(
        _ product: Product
    ) async throws -> (Product.PurchaseResult, Transaction?)
    
    /// Purchase a certain product.
    ///
    /// - Parameters:
    ///   - product: The product to purchase.
    ///   - options: Additional purchase options.
    @discardableResult
    func purchase(
        _ product: Product,
        options: Set<Product.PurchaseOption>
    ) async throws -> (Product.PurchaseResult, Transaction?)

    /// Sync StoreKit products and purchases to a context.
    func syncStoreData(
        to context: StoreContext
    ) async throws
}

public extension StoreService {

    /// Purchase a certain product.
    ///
    /// This function will sync the result to the context.
    @discardableResult
    func purchase(
        _ product: Product,
        syncWith context: StoreContext
    ) async throws -> (Product.PurchaseResult, Transaction?) {
        let result = try await purchase(product)
        if let transaction = result.1 {
            await context.updatePurchaseTransactions(with: transaction)
        }
        return result
    }

    /// Restore previous purchases.
    ///
    /// This function will sync the result to the context.
    func restorePurchases(
        with context: StoreContext
    ) async throws {
        let products = try await getProducts()
        await context.updateProducts(products)
        let transactions = try await getValidProductTransations()
        await context.updatePurchaseTransactions(transactions)
    }
}
