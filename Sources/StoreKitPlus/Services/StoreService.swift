//
//  StoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol inherits multiple store protocols, and can
/// be implemented by a single service that can take care of
/// many store-related operations.
public protocol StoreService: StoreProductService, StorePurchaseService, StoreSyncService {}
