//
//  ProductUsp+Label.swift
//  KankodaKit
//
//  Created by Daniel Saidi on 2024-12-04.
//  Copyright © 2024 Kankoda. All rights reserved.
//

import SwiftUI

public extension ProductUsp {

    /// This label can be used to display a ``ProductUsp``.
    struct Label: View {

        public init(_ usp: ProductUsp) {
            self.usp = usp
        }

        private let usp: ProductUsp

        public var body: some View {
            SwiftUI.Label(
                title: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(usp.title)
                            .font(.headline)
                        Text(usp.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                },
                icon: {
                    icon("house")
                        .opacity(0)
                        .overlay(icon(usp.iconName))
                }
            )
        }
    }

    /// This stack can display a list of ``ProductUsp``s.
    struct LabelStack: View {

        public init(_ usps: [ProductUsp]) {
            self.usps = usps
        }

        private let usps: [ProductUsp]

        public var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(usps.enumerated()), id: \.offset) {
                    ProductUsp.Label($0.element)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private extension ProductUsp.Label {

    func icon(
        _ name: String
    ) -> some View {
        Image(systemName: name)
            .font(.headline)
    }
}

#Preview {

    let usp1 = ProductUsp(
        title: "Short title",
        text: "Pretty long text to see how it handles line breaks.",
        iconName: "person"
    )

    let usp2 = ProductUsp(
        title: "A little longer title",
        text: "A short text.",
        iconName: "house"
    )

    return VStack(alignment: .leading, spacing: 20) {
        ProductUsp.Label(usp1)
        ProductUsp.Label(usp2)
    }
}
