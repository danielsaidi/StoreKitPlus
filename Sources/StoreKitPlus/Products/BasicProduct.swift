//
//  BasicProduct.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2024-12-04.
//  Copyright © 2024-2026 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This product representation type can be used to refer to
/// an App Store product with just its ID and name.
///
/// The ``StoreContext`` has ways to fetch App Store product
/// values for any ``ProductRepresentable``.
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

public extension BasicProduct {

    static func preview(_ name: String) -> Self {
        .init(
            id: "com.danielsaidi.storekitplus.product.preview",
            name: name
        )
    }
}
