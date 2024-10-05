//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

@available(*, deprecated, message: "Just use StandardStoreService instead.")
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
