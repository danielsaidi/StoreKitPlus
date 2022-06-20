import XCTest
@testable import StoreKitPlus

final class StoreContextTests: XCTestCase {

    var context: StoreContext!

    override func setUp() {
        context = StoreContext()
    }

    func testPersistsProductIds() throws {
        let ids = ["1", "2", "3"]
        context.productIds = ids
        let context2 = StoreContext()
        XCTAssertEqual(context2.productIds, ids)
    }

    func testPersistsPurchasedProductIds() throws {
        let ids = ["1", "2", "3"]
        context.purchasedProductIds = ids
        let context2 = StoreContext()
        XCTAssertEqual(context2.purchasedProductIds, ids)
    }
}
