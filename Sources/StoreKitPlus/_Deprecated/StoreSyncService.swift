//
//  StoreSyncService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

@available(*, deprecated, message: "Just use StoreService instead.")
public protocol StoreSyncService: AnyObject {

    func syncStoreData(
        to context: StoreContext
    ) async throws
}

@available(*, deprecated, message: "Just use StoreService instead.")
public extension StoreSyncService {

    @available(*, deprecated, message: "You have to pass in a context now.")
    func syncStoreData() async throws {
        try await syncStoreData(to: .init())
    }
}
