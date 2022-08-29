//
//  SubscriptionScreen.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This screen can be used to present subscriptions options to
 the user and let the user sign up for any of them.

 The screen currently presents a monthly and a yearly option,
 where the yearly is optional and will show a saving
 without room for adjustments. You can also provide a set of
 USPs, freeform text and a link to your Terms and Conditions.
 */
public struct SubscriptionScreen: View {

    /**
     Create a subscription screen.

     - Parameters:
       - service: The service to use to fetch and subscribe to products.
       - monthlyProductId: The monthly subscription product ID.
       - yearlyProductId: The yearly  subscription product ID, if any.
     */
    public init(
        service: StoreService,
        monthlyProductId: ProductID,
        yearlyProductId: ProductID?
    ) {
        self.service = service
        self.monthlyProductId = monthlyProductId
        self.yearlyProductId = yearlyProductId
    }

    public typealias ProductID = String

    private let service: StoreService
    private let monthlyProductId: ProductID
    private let yearlyProductId: ProductID?

    public var body: some View {
        Text("Hello, World!")
    }
}

import StoreKit

enum TestError: Error {

    case general
}

private class MockService: StoreService {

    func getProducts() async throws -> [Product] { [] }

    func purchase(_ product: Product) async throws -> Product.PurchaseResult {
        throw TestError.general


    }

    func restorePurchases() async throws {}

    func syncStoreData() async throws {}
}

struct SubscriptionScreen_Previews: PreviewProvider {

    static var previews: some View {
        Color.red
    }
}
