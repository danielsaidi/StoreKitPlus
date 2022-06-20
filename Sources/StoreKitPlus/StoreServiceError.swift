//
//  StoreServiceError.swift
//  SwiftKit
//
//  Created by Daniel Saidi on 2021-11-08.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This enum lists errors that can be thrown by store services.
 */
public enum StoreServiceError: Error {
    
    /// This error is thrown if a transaction can't be verified.
    case invalidTransaction(Transaction, VerificationResult<Transaction>.VerificationError)
}
