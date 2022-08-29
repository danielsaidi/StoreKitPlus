//
//  StoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol can be implemented by any classes that can be
 used to retrieve StoreKit products.

 The protocol is implemented by ``StandardStoreService``, so
 you can use that class to get a standard implementation, or
 subclass it to customize its behavior.
 */
public protocol StoreProductService: AnyObject {

    /**
     Get all available products.
     */
    func getProducts() async throws -> [Product]
}
