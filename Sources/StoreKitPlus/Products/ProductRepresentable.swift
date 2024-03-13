//
//  ProductRepresentable.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by types that are intended
 to represent an app's StoreKit products.

 This protocl can be used to provide a local product catalog
 that uses the same product IDs as the real StoreKit product
 catalog. This can be used to provide any additional product
 information, unit test product logic, present products even
 if the app is unable to sync with StoreKit, e.g. when it is
 offline, etc.
 */
public protocol ProductRepresentable: Identifiable {

    var id: ProductID { get }
}

public extension Collection where Element: ProductRepresentable {

    /// Get all products available in a ``StoreContext``.
    func available(_ context: StoreContext) -> [Self.Element] {
        let ids = context.productIds
        return self.filter { ids.contains($0.id) }
    }

    /// Get all products purchased in a ``StoreContext``.
    func purchased(in context: StoreContext) -> [Self.Element] {
        let ids = context.purchasedProductIds
        return self.filter { ids.contains($0.id) }
    }
}
