//
//  StoreContext+Products.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This protocol can be implemented by store transactions that
 can be validated.

 Valid transactions have no revocation date and also have no
 expiration date that has passed.

 This type is implemented by the StoreKit `Translation` type.
 */
public protocol ValidatableTransaction {

    /**
     The date, if any, when the transaction expired.
     */
    var expirationDate: Date? { get }

    /**
     The date, if any, when the transaction was revoked.
     */
    var revocationDate: Date? { get }
}

extension Transaction: ValidatableTransaction {}

public extension ValidatableTransaction {

    /**
     Whether or not the transaction is valid.

     A valid transaction has no revocation date and also has
     no expiration date that has passed.
     */
    var isValid: Bool {
        if revocationDate != nil { return false }
        guard let date = expirationDate else { return true }
        return date > Date()
    }
}
