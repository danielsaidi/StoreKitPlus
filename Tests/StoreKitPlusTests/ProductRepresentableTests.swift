import XCTest
@testable import StoreKitPlus

final class ProductRepresentableTests: XCTestCase {

    var context: StoreContext!

    override func setUp() {
        context = StoreContext()
    }

    func testFilteringProductsByPurchaseState() throws {
        let ids = ["1", "3"]
        context.purchasedProductIds = ids
        let products = TestProduct.allCases
        let purchased = products.purchased(in: context)
        XCTAssertEqual(purchased, [.first, .third])
    }
}

private enum TestProduct: Int, CaseIterable, Equatable, ProductRepresentable {

    case first = 1, second, third

    var id: String {
        "\(rawValue)"
    }
}
