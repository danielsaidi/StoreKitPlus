//
//  StoreSyncService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol can be implemented by any classes that can be
 used to sync StoreKit purchase and product information.

 The protocol is implemented by ``StandardStoreService``, so
 you can use that class to get a standard implementation, or
 subclass it to customize its behavior.
 */
public protocol StoreSyncService: AnyObject {

    /**
     Sync StoreKit product and purchase information.
     */
    func syncStoreData() async throws
}
