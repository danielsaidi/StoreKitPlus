//
//  StoreServiceError.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This enum defines store service-speific errors.
public enum StoreServiceError: Error {
    
    /// This error is thrown if a transaction can't be verified.
    case invalidTransaction(Transaction, VerificationResult<Transaction>.VerificationError)
    
    /// This error is thrown if the platform doesn't support a purchase.
    case unsupportedPlatform(_ message: String)
}
