//
//  BasicProduct.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2024-12-04.
//

import StoreKit

/// This basic product representation can be used to refer to an App Store product
/// with just its ID and name.
///
/// The ``StoreContext`` has ways to fetch product info for a basic product.
public struct BasicProduct: Identifiable, ProductRepresentable, Sendable {

    /// Create a basic product representation.
    ///
    /// - Parameters:
    ///   - id: The App Store string ID of the product.
    ///   - name: The product display name.
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    /// The App Store string ID of the product.
    public let id: String

    /// The product display name.
    public let name: String
}

public extension StoreContext {

    /// Whether a certain basic product is purchased.
    func isProductPurchased(_ prod: BasicProduct) -> Bool {
        isProductPurchased(id: prod.id)
    }

    /// Get a StoreKit product for a certain basic product.
    func product(_ prod: BasicProduct) -> Product? {
        product(withId: prod.id)
    }
}

public extension BasicProduct {

    static func preview(_ name: String) -> Self {
        .init(
            id: "com.danielsaidi.storekitplus.product.preview",
            name: name
        )
    }
}
