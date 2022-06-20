import XCTest
@testable import StoreKitPlus

final class StoreContextProductTests: XCTestCase {

    var context: StoreContext!

    override func setUp() {
        context = StoreContext()
    }

    func testIsProductPurched() throws {
        let ids = ["1", "2", "3"]
        context.purchasedProductIds = ids
        XCTAssertTrue(context.isProductPurchased(id: "1"))
        XCTAssertFalse(context.isProductPurchased(id: "5"))
    }
}
