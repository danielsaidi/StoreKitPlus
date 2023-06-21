//
//  ProductRepresentable.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
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

    /**
     Get all products that are available in a ``StoreContext``.

     - Parameters:
       - context: The context to check.
     */
    func available(_ context: StoreContext) -> [Self.Element] {
        let ids = context.productIds
        return self.filter { ids.contains($0.id) }
    }

    /**
     Get all products that are purchased in a ``StoreContext``.

     - Parameters:
       - context: The context to check.
     */
    func purchased(in context: StoreContext) -> [Self.Element] {
        let ids = context.purchasedProductIds
        return self.filter { ids.contains($0.id) }
    }
}
