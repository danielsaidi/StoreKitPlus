import XCTest
import StoreKit
import StoreKitPlus

final class Product_YearlySavingTests: XCTestCase {

    func testCalculatingYearlySavingsPercentageRequiresPositivePrices() throws {
        let result1 = Product.yearlySavingsPercentage(
            forYearlyPrice: -1,
            comparedToMonthlyPrice: 10
        )
        let result2 = Product.yearlySavingsPercentage(
            forYearlyPrice: 100,
            comparedToMonthlyPrice: -1
        )
        XCTAssertNil(result1)
        XCTAssertNil(result2)
    }

    func testCanCalculateYearlySavingsPercentage() throws {
        let percentage = Product.yearlySavingsPercentage(
            forYearlyPrice: 60,
            comparedToMonthlyPrice: 10  // 120
        )
        XCTAssertEqual(percentage, 0.5)
    }

    func testCanCalculateYearlySavingsDisplayPercentage() throws {
        let percentage = Product.yearlySavingsDisplayPercentage(
            forYearlyPrice: 100,
            comparedToMonthlyPrice: 10  // 120
        )
        XCTAssertEqual(percentage, 17)
    }
}

private struct TestTransaction: ValidatableTransaction {

    let expirationDate: Date?
    let revocationDate: Date?
}
