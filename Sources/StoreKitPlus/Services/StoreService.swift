//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol can be implemented by any classes that can
/// be used to fetch and purchase products, restore purchase
/// information, etc.
///
/// Although some operations can be performed directly using
/// StoreKit like `Product.products(for:)`, the service lets
/// you customize any part of the StoreKit integration.
public protocol StoreService {

    /// Get all available products.
    func getProducts() async throws -> [Product]

    /// Purchase a certain product.
    func purchase(
        _ product: Product
    ) async throws -> Product.PurchaseResult

    /// Restore previous purchases.
    @discardableResult
    func restorePurchases() async throws -> [Transaction]

    /// Sync StoreKit products and purchases to a context.
    func syncStoreData(
        to context: StoreContext
    ) async throws
}

public extension StoreService {

    @available(*, deprecated, message: "You have to pass in a context now.")
    func syncStoreData() async throws {
        try await syncStoreData(to: .init())
    }
}

