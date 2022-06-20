//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol can be implemented by any classes that can be
 used to manage store products.
 */
public protocol StoreService: AnyObject {
    
    /**
     Get all available products.
     */
    func getProducts() async throws -> [Product]
    
    /**
     Purchase a certain product.

     - Parameters:
       - product: The product to purchase.
     */
    func purchase(_ product: Product) async throws -> Product.PurchaseResult
    
    /**
     Restore purchases that have not been synced yet.
     */
    func restorePurchases() async throws
    
    /**
     Sync product and purchase information from the store to
     any implementation defined sync destination.
     */
    func syncStoreData() async throws
}
