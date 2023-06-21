//
//  Product+ProductRepresentable.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2023-06-21.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import StoreKit

public extension Product {

    /// Get AppStore products by their local representations.
    static func products<T: ProductRepresentable>(
        for representations: [T]
    ) async throws -> [Product] {
        let ids = representations.map { $0.id }
        return try await products(for: ids)
    }
}
