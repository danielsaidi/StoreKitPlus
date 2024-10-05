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
public protocol StoreService: StorePurchaseService, StoreSyncService {

    /// Get all available products.
    func getProducts() async throws -> [Product]
}
