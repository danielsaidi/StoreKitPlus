//
//  ProductRepresentable.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by types that represent a StoreKit product.
///
/// This protocol can be used to define a local product that uses the same product
/// ID as a real StoreKit product. The local product can then provide any additional
/// information, unit test product-based logic, present your products even if the app
/// is unable to sync with StoreKit, e.g. when it is offline, etc.
public protocol ProductRepresentable: Identifiable {

    var id: ProductID { get }
}

public extension Collection where Element: ProductRepresentable {

    /// Get all products available in a ``StoreContext``.
    func available(in context: StoreContext) -> [Self.Element] {
        let ids = context.productIds
        return self.filter { ids.contains($0.id) }
    }

    /// Get all products purchased in a ``StoreContext``.
    func purchased(in context: StoreContext) -> [Self.Element] {
        let ids = context.purchasedProductIds
        return self.filter { ids.contains($0.id) }
    }
}
