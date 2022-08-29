//
//  StoreServiceError.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This enum lists errors that can be thrown by store services.
 */
public enum StoreServiceError: Error {
    
    /// This error is thrown if a transaction can't be verified.
    case invalidTransaction(Transaction, VerificationResult<Transaction>.VerificationError)
}
