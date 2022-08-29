//
//  StorePurchaseService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol can be implemented by any classes that can be
 used to perform StoreKit product purchase operations.

 The protocol is implemented by ``StandardStoreService`` and
 ``StandardStorePurchaseService``.
 */
public protocol StorePurchaseService: AnyObject {

    /**
     Purchase a certain product.

     - Parameters:
       - product: The product to purchase.
     */
    func purchase(_ product: Product) async throws -> Product.PurchaseResult

    /**
     Restore previous purchases.
     */
    func restorePurchases() async throws
}
