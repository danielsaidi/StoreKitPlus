//
//  ProductUsp.swift
//  KankodaKit
//
//  Created by Daniel Saidi on 2024-12-04.
//  Copyright © 2024-2026 Kankoda. All rights reserved.
//

import SwiftUI

/// This type defines a "unique selling point" for a product.
///
/// A USP can be rendered with a ``ProductUsp/Label``, and a
/// USP list can be rendered with a ``ProductUsp/LabelStack``.
public struct ProductUsp {

    /// Create a custom USP.
    ///
    /// - Parameters:
    ///   - title: The localized USP title.
    ///   - text: The localized USP description text.
    ///   - iconName: The SF Symbol name for the USP.
    public init(
        title: LocalizedStringResource,
        text: LocalizedStringResource,
        iconName: String
    ) {
        self.title = title
        self.text = text
        self.iconName = iconName
    }
    
    /// The localized USP title.
    public let title: LocalizedStringResource

    /// The localized USP description text.
    public let text: LocalizedStringResource

    /// The SF Symbol name for the USP.
    public let iconName: String
}
