//
//  StoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol can be implemented by any classes that can
/// be used to retrieve StoreKit products.
public protocol StoreProductService: AnyObject {

    /// Get all available products.
    func getProducts() async throws -> [Product]
}
