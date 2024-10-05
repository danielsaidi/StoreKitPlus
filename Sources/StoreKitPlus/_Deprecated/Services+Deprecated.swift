public extension StandardStorePurchaseService {

    @available(*, deprecated, message: "This class no longer takes a context. You must manually keep a context in sync.")
    convenience init(
        productIds: [String],
        context: StoreContext
    ) {
        self.init(productIds: productIds)
    }
}

public extension StandardStoreService {

    @available(*, deprecated, message: "This class no longer takes a context. You must manually keep a context in sync.")
    convenience init(
        productIds: [String],
        context: StoreContext = StoreContext(),
        productService: StoreProductService? = nil,
        purchaseService: StorePurchaseService? = nil
    ) {
        self.init(
            productIds: productIds,
            productService: productService,
            purchaseService: purchaseService
        )
    }

    @available(*, deprecated, message: "This class no longer takes a context. You must manually keep a context in sync.")
    convenience init<Product: ProductRepresentable>(
        products: [Product],
        context: StoreContext = StoreContext(),
        productService: StoreProductService? = nil,
        purchaseService: StorePurchaseService? = nil
    ) {
        self.init(
            productIds: products.map { $0.id },
            productService: productService,
            purchaseService: purchaseService
        )
    }
}
