//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol inherits multiple store service protocols and
 can be used if you want a single service that takes care of
 everything store-related.
 */
public protocol StoreService: AnyObject, StoreProductService, StorePurchaseService, StoreSyncService {}
