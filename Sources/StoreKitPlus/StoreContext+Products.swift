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
    func isAnyProductPurchased(
        in ids: [ProductID]
    ) -> Bool {
        ids.contains(where: isProductPurchased)
    }

    /// Check whether a certain product is purchased.
    func isAnyProductPurchased(
        in products: [any ProductRepresentable]
    ) -> Bool {
        products.contains(where: isProductPurchased)
    }

    /// Check whether a certain product is purchased.
    func isAnyProductPurchased(
        in product: Product
    ) -> Bool {
        products.contains(where: isProductPurchased)
    }

    /// Check whether a certain product is purchased.
    func isProductPurchased(id: ProductID) -> Bool {
        purchasedProductIds.contains(id)
    }

    /// Check whether a certain product is purchased.
    func isProductPurchased(_ prod: any ProductRepresentable) -> Bool {
        isProductPurchased(id: prod.id)
    }

    /// Check whether a certain product is purchased.
    func isProductPurchased(_ prod: Product) -> Bool {
        isProductPurchased(id: prod.id)
    }

    /// Get a product from ``products`` with a certain ID.
    func product(withId id: String) -> Product? {
        products.first { $0.id == id }
    }

    /// Get a product from ``products`` for a certain model.
    func product(for prod: any ProductRepresentable) -> Product? {
        product(withId: prod.id)
    }
}
