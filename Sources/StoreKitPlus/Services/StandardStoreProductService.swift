//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This class can be used to retrieve StoreKit products.
///
/// This standard implementation will just return StoreKit's
/// `Product.products(for:)` but you can customize it if you
/// have to perform other operations while fetching products.
open class StandardStoreProductService: StoreProductService {

    /// Create a service instance for the provided IDs.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to fetch.
    public init(productIds: [String]) {
        self.productIds = productIds
    }

    private let productIds: [String]

    open func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }
}
