# Getting Started

This article describes how you get started with StoreKitPlus.


## Services

StoreKitPlus has services and observable state that help you integrate with StoreKit.

 * ``StoreProductService`` can be implemented by types that can fetch StoreKit products.
 * ``StorePurchaseService`` can be implemented by types that can purchase StoreKit products.
 * ``StoreSyncService`` can be implemented by types that can sync purchases and products.

There is also a ``StoreService`` protocol that implements all these protocols, for when you want a single service to do everything.

``StandardStoreProductService``, ``StandardStorePurchaseService`` and ``StandardStoreService`` implement these protocols and can be subclassed to customize their behavior.



## Observable state

StoreKitPlus has an observable ``StoreContext`` that keeps track of the available and purchased products for an app. It can be injected into the store services to automatically be kept in sync.

For instance, injecting a context into a ``StandardStoreService`` and calling ``StoreSyncService/syncStoreData()`` will automatically write products and transactions to the context:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(
    productIds: productIds,
    context: context
)
try await service.syncStoreData()
```

Although StoreKit products and transactions are not codable, this context will persist products and purchases by their ID, which means that you can use local product representations to keep track of products and purchases in your app.



## Local product representations

You can use the ``ProductRepresentable`` protocol protocol to create local product representations that can be mapped to to the real products by ID.

For instance, here we define an `AppProduct` enum that maps to real App Store Connect product IDs:

```swift
enum AppProduct: String, CaseIterable, ProductRepresentable {

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
    context: context)
```

You can also use the context to filter a product collection:

```swift
let available = products.available(in: context)
let purchased = products.purchased(in: context)
```

A benefit of using local product representations, is that the context will persist fetched and purchased product IDs, which means that the data will be available even if the app goes offline.  

Since some operations require real StoreKit `Product` values, you should display a loading indicator over your purchase buttons if the app has not yet fetched products from StoreKit. 




## Fetching products

You can use the native `Product` type to fetch products with StoreKit:

```swift
let productIds = ["com.your-app.productid"]
let products = try await Product.products(for: productIds)
```

You can also use a ``StoreProductService``, for instance this standard one:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreProductService(
    productIds: productIds, 
    context: context)
let products = try await service.getProducts()
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Purchasing products

You can use the native `Product` type to purchase products with StoreKit:

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

However, purchases involve a bunch of steps and can become pretty complicated. To make things easier, you can also use a ``StorePurchaseService``, for instance this standard one:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStorePurchaseService(productIds: productIds, context: context)
let result = try await service.purchase(product)
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Restoring purchases

You can use the native `StoreKit.Product` type to verify transactions and see which ones that are purchased, not expired, not revoked etc.

However, this involves a bunch of steps and can become pretty complicated. To make things easier, you can also use a ``StorePurchaseService``, for instance this standard one:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStorePurchaseService(
    productIds: productIds,
    context: context
)
try await service.restorePurchases()
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Syncing store data

To perform a product and purchase sync, you can fetch products and transactions from StoreKit.

However, this involves a bunch of steps and can become pretty complicated. To make things easier, you can also use a ``StoreSyncService``, for instance this standard one:

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(
    productIds: productIds,
    context: context
)
try await service.syncStoreData()
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Syncing store data on app launch

To sync data when your app launches or becomes active, you can listen to its scene phase change:

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
    // can create a service directly, like this:
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



## StoreKit configuration files

StoreKitPlus is just a small layer on top of StoreKit, which means that all the amazing StoreKit tools provided by Xcode works as expected. 

For instance, StoreKit configuration files work just like when you just use the native StoreKit framework.
