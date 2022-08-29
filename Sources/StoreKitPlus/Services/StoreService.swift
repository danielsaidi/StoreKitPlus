//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol inherits multiple store protocols, and can be
 used if you want a single service that does everything.
 */
public protocol StoreService: AnyObject, StoreProductService, StorePurchaseService, StoreSyncService {}
