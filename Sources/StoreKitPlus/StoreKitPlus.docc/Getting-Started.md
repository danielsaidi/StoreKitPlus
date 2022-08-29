# Getting Started

StoreKitPlus is a Swift-based library that adds extra functionality for working with StoreKit 2, like extensions, observable state, store services, etc.

StoreKitPlus builds on the great foundation that is provided by StoreKit 2 and just aims to make it easier to use StoreKit 2 in e.g. SwiftUI. 


## Services

StoreKitPlus has a bunch of service protocols and classes that help you integrate with StoreKit.

 * ``StoreProductService`` can be implemented by classes that can be used to retrieve StoreKit products.
 * ``StorePurchaseService`` can be implemented by classes that can be used to perform StoreKit product purchase operations.
 * ``StoreSyncService`` can be implemented by classes that can be used to sync StoreKit purchase and product information.

There is also a ``StoreService`` protocol that implements all these protocols, for when you want a single service to do everything.

The ``StandardStoreProductService``, ``StandardStorePurchaseService`` and ``StandardStoreService`` service classes implement these protocols and can be subclassed in case you want to customize the standard behavior. 

This abstract service layer lets you communicate with StoreKit in a way that makes it possible to customize functionality, mock services in unit tests, etc. It also lets you reuse functionality for handling purchases and transactions, which otherwise can become complicated.



## Observable state

StoreKitPlus has an observable ``StoreContext`` class that can be used to observe the state for a certain app. It lets you keep track of available and purchased products and can be injected into services to automatically keep the context in sync.

For instance, injecting a context into a ``StandardStoreService`` and calling ``StoreSyncService/syncStoreData()`` will automatically write products and transactions to the context:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(
    productIds: productIds,
    context: context
)
try await Product.syncStoreData()
```

Although StoreKit products and transactions are not codable, the context will persist fetched and purchased product IDs, which means that you can use local product representations (read more further down) to keep track of products and purchases even if your app fails to communicate with StoreKit, for instance when it's offline.



## Fetching products

To fetch products with StoreKit 2, you can use `StoreKit.Product.products`:

```swift
let productIds = ["com.your-app.productid"]
let products = try await Product.products(for: productIds)
```

However, you can also use the StoreKitPlus ``StoreProductService`` protocol and its implementations to fetch products:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreProductService(
    productIds: productIds,
    context: context
)
let products = try await service.getProducts()
```

The standard service implementations communicate directly with StoreKit and sync the result to the provided ``StoreContext``.



## Purchasing products

To purchase products with StoreKit 2, you can use `StoreKit.Product.purchase`:

```swift
let result = try await product.purchase()
switch result {
    case .success(let result): try await handleTransaction(result)  // This can become complicated
    case .pending: break
    case .userCancelled: break
    @unknown default: break
}
return result
```

However, purchases involve a bunch of steps and can become pretty complicated. To make things easier, you can use the StoreKitPlus ``StorePurchaseService`` protocol and its implementations to purchase products:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStorePurchaseService(
    productIds: productIds,
    context: context
)
let result = try await service.purchase(product)
```

The standard service implementations communicate directly with StoreKit and sync the result to the provided ``StoreContext``.



## Restoring purchases

To restore purchase with StoreKit 2, you can use `StoreKit.Transaction.latest(for:)` and verify each transaction to see that it's purchased, not expired and not revoked.

However, much like with purchases, transactions involve a bunch of steps and can become pretty complicated. To make things easier, you can use the StoreKitPlus ``StorePurchaseService`` protocol and its implementations to restore purchases:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStorePurchaseService(
    productIds: productIds,
    context: context
)
try await service.restorePurchases()
```

The standard service implementations communicate directly with StoreKit and sync the result to the provided ``StoreContext``.



## Syncing store data

To perform a full product and purchase sync with StoreKit 2, you can fetch products and transactions from StoreKit.

However, much like with purchases, this involves a bunch of steps and can become pretty complicated. To make things easier, you can use the StoreKitPlus ``StoreSyncService`` protocol and its implementations to sync store information:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(
    productIds: productIds,
    context: context
)
try await service.syncStoreData()
```

The standard service implementation communicates directly with StoreKit and syncs the result to the provided ``StoreContext``.



## Syncing store data on app launch

To sync data when the app launches or is waken up from the background, you can make your app listen to the scene phase change. In SwiftUI, this can be implemented like this:

```swift
@main
struct MyApp: App {

    @StateObject
    private var storeContext = StoreContext()

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .onChange(of: scenePhase, perform: syncStoreData)
                .environmentObject(storeContext)
        }
    }
}

private extension MyApp {

    // I use a service provider to resolve services, but you
    // can create a service directly or use a way that suits
    // your app. Let's just create one directly in this demo:
    var storeService: StoreService {
        let productIds = ["com.your-app.productid"]
        let service = StandardStoreService(
            productIds: productIds,
            context: storeContext
        )
    }

    func syncStoreData(for phase: ScenePhase) {
        guard phase == .active else { return 
        Task {
            try await storeService.syncStoreData()
        }
    }
}
```

Since the standard implementations automatically sync changes with the provided context, injecting the context as an environment object will make the global state available to the entire app.



## Local product representations

If you want to have a local representation of your StoreKit products, you can use the ``ProductRepresentable`` protocol, which is an easy way to provide identifiable product types that can be matched with real product IDs.

For instance, here we define an app-specific product, where the id:s reflect the real product id:s that are defined in App Store Connect:

```swift
enum AppProduct: CaseIterable, String, ProductRepresentable {

    case premiumMonthly = "com.myapp.products.premium.monthly"
    case premiumYearly = "com.myapp.products.premium.yearly"

    var id: String { rawValue }
}
```

You can now use this collection to initialize a standard store service:

```swift
let products = AppProduct.allCases
let context = StoreContext()
let service = StandardStoreService(
    products: products,
    context: context
)
```

You can also match any product collection with a context's purchased product id:s:

```swift
let products = AppProduct.allCases
let context = StoreContext()
let purchased = products.purchased(in: context)
```

One benefit of using local product representations, is that since the context will persist the id:s of fetched and purchased products, you will be able to check if a product has been purchased or not, even if the app fails to fetch StoreKit transactions.  

However, some operations require that you provide a real StoreKit `Product`, for instance purchasing a product. As such, you may want to display a loading indicator over your purchase buttons if the app has not yet fetched products from StoreKit. 



## StoreKit configuration files

StoreKitPlus is just a small layer on top of StoreKit, which means that all the amazing StoreKit tools provided by Xcode works as expected. For instance, StoreKit configuration files work just like when you just use the native StoreKit api.
