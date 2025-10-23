//
//  ProductUsp.swift
//  KankodaKit
//
//  Created by Daniel Saidi on 2024-12-04.
//  Copyright © 2024 Kankoda. All rights reserved.
//

import SwiftUI

/// This type defines a "unique selling point" for a product.
///
/// Listing USPs is a way to tell people why they should purchase your product. A
/// USP can be rendered with a ``ProductUsp/Label`` and an array of USPs
/// can be rendered with a ``ProductUsp/LabelStack``.
public struct ProductUsp {

    /// Create a custom USP.
    ///
    /// - Parameters:
    ///   - title: The localized USP title.
    ///   - text: The localized USP description text.
    ///   - iconName: The SF Symbol name for the USP.
    public init(
        title: LocalizedStringKey,
        text: LocalizedStringKey,
        iconName: String
    ) {
        self.title = title
        self.text = text
        self.iconName = iconName
    }
    
    /// The localized USP title.
    public let title: LocalizedStringKey

    /// The localized USP description text.
    public let text: LocalizedStringKey

    /// The SF Symbol name for the USP.
    public let iconName: String
}
