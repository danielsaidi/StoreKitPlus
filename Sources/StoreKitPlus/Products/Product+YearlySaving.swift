//
//  Product+YearlySaving.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2024-12-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import StoreKit

public extension Product {

    /// Get a yearly savings in percentages when comparing a
    /// yearly product with a monthy one.
    ///
    /// - Returns: A raw 0-1 percentage.
    static func yearlySavingsPercentage(
        forYearlyProduct yearly: Product,
        comparedToMonthlyProduct monthly: Product
    ) -> Decimal? {
        yearlySavingsPercentage(
            forYearlyPrice: yearly.price,
            comparedToMonthlyPrice: monthly.price
        )
    }

    /// Get a yearly savings in percentages when comparing a
    /// yearly price with a monthy one.
    ///
    /// - Returns: A raw 0-1 percentage.
    static func yearlySavingsPercentage(
        forYearlyPrice yearly: Decimal,
        comparedToMonthlyPrice monthly: Decimal
    ) -> Decimal? {
        guard yearly > 0 else { return nil }
        guard monthly > 0 else { return nil }
        let percentage = 1 - (yearly / (12 * monthly))
        return percentage
    }

    /// Get a yearly savings in percentages when comparing a
    /// yearly product with a monthy product variant.
    ///
    /// - Returns: A 0-100 (not 0-1) display percentage.
    static func yearlySavingsDisplayPercentage(
        forYearlyProduct yearly: Product,
        comparedToMonthlyProduct monthly: Product
    ) -> Int? {
        yearlySavingsDisplayPercentage(
            forYearlyPrice: yearly.price,
            comparedToMonthlyPrice: monthly.price
        )
    }

    /// Get a yearly savings in percentages when comparing a
    /// yearly product with a monthy product variant.
    ///
    /// - Returns: A 0-100 (not 0-1) display percentage.
    static func yearlySavingsDisplayPercentage(
        forYearlyPrice yearly: Decimal,
        comparedToMonthlyPrice monthly: Decimal
    ) -> Int? {
        yearlySavingsPercentage(
            forYearlyPrice: yearly,
            comparedToMonthlyPrice: monthly
        )?.asDisplayPercentageValue()
    }
}

private extension Decimal {

    func asDisplayPercentageValue() -> Int {
        let number = self as NSNumber
        let result = 100 * Double(truncating: number)
        return Int(result.rounded())
    }
}
