//
//  StoreContext+Products.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

public extension StoreContext {
    
    /**
     Check whether or not a certain product is purchased.

     - Parameters:
       - id: The ID of the product to check.
     */
    func isProductPurchased(id: String) -> Bool {
        purchasedProductIds.contains(id)
    }
    
    /**
     Check whether or not a certain product is purchased.

     - Parameters:
       - product: The product to check.
     */
    func isProductPurchased(_ product: Product) -> Bool {
        isProductPurchased(id: product.id)
    }

    /**
     Get a product with a certain ID.

     This function will only return matching products if the
     ``products`` array has been synced with StoreKit.

     - Parameters:
       - id: The ID of the product to fetch.
     */
    func product(withId id: String) -> Product? {
        products.first { $0.id == id }
    }
}
