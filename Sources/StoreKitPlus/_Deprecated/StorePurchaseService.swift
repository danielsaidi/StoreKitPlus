//
//  StorePurchaseService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

@available(*, deprecated, message: "Just use StoreService instead.")
public protocol StorePurchaseService: AnyObject {

    func purchase(_ product: Product) async throws -> Product.PurchaseResult

    @discardableResult
    func restorePurchases() async throws -> [Transaction]
}
