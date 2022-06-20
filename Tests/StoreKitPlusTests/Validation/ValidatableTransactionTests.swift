import XCTest
import StoreKitPlus

final class ValidatableTransactionTests: XCTestCase {

    func testTransactionIsNotValidIfItHasBeenRevoked() throws {
        let transaction = TestTransaction(
            expirationDate: nil,
            revocationDate: Date())
        XCTAssertFalse(transaction.isValid)
    }

    func testTransactionIsNotValidIfItHasExpired() throws {
        let transaction = TestTransaction(
            expirationDate: Date().addingTimeInterval(-1_000),
            revocationDate: nil)
        XCTAssertFalse(transaction.isValid)
    }

    func testTransactionIsValidIfItHasNotExpiredYet() throws {
        let transaction = TestTransaction(
            expirationDate: Date().addingTimeInterval(1_000),
            revocationDate: nil)
        XCTAssertTrue(transaction.isValid)
    }

    func testTransactionIsValidIfItNotBeenRevokedNorExpired() throws {
        let transaction = TestTransaction(
            expirationDate: nil,
            revocationDate: nil)
        XCTAssertTrue(transaction.isValid)
    }
}

private struct TestTransaction: ValidatableTransaction {

    let expirationDate: Date?
    let revocationDate: Date?
}
