//
//  StorePurchaseService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol can be implemented by any classes that can
/// be used to perform StoreKit product purchase operations.
public protocol StorePurchaseService: AnyObject {

    /// Purchase the provided product.
    func purchase(_ product: Product) async throws -> Product.PurchaseResult

    /// Restore all purchases and get the valid transactions.
    @discardableResult
    func restorePurchases() async throws -> [Transaction]
}
