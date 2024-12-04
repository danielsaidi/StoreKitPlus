//
//  BasicProduct.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2024-12-04.
//

import SwiftUI

public struct BasicProduct: Identifiable, ProductRepresentable {

    /// Create a new product.
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
