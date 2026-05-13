//
//  StoreContext+Products.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2026 Daniel Saidi. All rights reserved.
//

import StoreKit

public extension StoreContext {
    
    /// Check whether a certain product is purchased.
    func isProductPurchased(id: ProductID) -> Bool {
        purchasedProductIds.contains(id)
    }

    /// Check whether a certain product is purchased.
    func isProductPurchased(_ product: any ProductRepresentable) -> Bool {
        isProductPurchased(id: product.id)
    }

    /// Check whether a certain product is purchased.
    func isProductPurchased(_ product: Product) -> Bool {
        isProductPurchased(id: product.id)
    }

    /// Get a product from ``products`` with a certain ID.
    ///
    /// - Parameters:
    ///   - id: The ID of the product to fetch.
    func product(withId id: String) -> Product? {
        products.first { $0.id == id }
    }

    /// Get a StoreKit product for a certain product model.
    ///
    /// - Parameters:
    ///   - prod: The local product representation to fetch.
    func product(for prod: any ProductRepresentable) -> Product? {
        product(withId: prod.id)
    }
}
