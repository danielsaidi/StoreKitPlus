# Getting Started

This article describes how you get started with StoreKitPlus.

@Metadata {

    @PageImage(
        purpose: card,
        source: "Page",
        alt: "Page icon"
    )

    @PageColor(blue)
}


StoreKitPlus has services and observable state that help you integrate with StoreKit.



## Services

A ``StoreService`` can be used to integrate with StoreKit, such as fetching and purchasing products, restoring purchases, etc. 

You can use the ``StandardStoreService`` as is, or subclass it to make modifications to any part of the StoreKit integration.



## Observable state

StoreKitPlus has an observable ``StoreContext`` that keeps track of the available and purchased products for an app. It can be injected into the store service's functions to automatically keep it in sync.

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

You can also use a ``StoreService``, for instance this standard one:

```swift
let ids = ["com.your-app.productid"]
let service = StandardStoreService(productIds: ids)
let products = try await service.getProducts()
```

You can subclass ``StandardStoreService`` to customize the fetch operation.



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

Since purchases involve a bunch of steps and can become complicated, you can also use a ``StoreService``:

```swift
let ids = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStorePurchaseService(productIds: ids)
let result = try await service.purchase(product, syncWith: context)
```

The ``StandardStoreService`` will automatically verify and finish the purchase transactions.



## Restoring purchases

You can use the native `StoreKit.Product` to verify transactions and see which that are purchased, not expired, not revoked etc.

However, this involves many steps and can become complicated. To make things easier, you can also use a ``StoreService``:

```swift
let ids = ["com.your-app.productid"]
let service = StandardStorePurchaseService(productIds: ids)
try await service.restorePurchases(with: context)
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Syncing store data

To perform a product and purchase sync, you can fetch products and transactions from StoreKit.

Using a ``StoreService`` lets you easily sync all data to a ``StoreContext``:

```swift
let ids = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(productIds: ids)
try await service.syncStoreData(to: context)
```

The standard service communicates with StoreKit and syncs the result with the provided context.



## Syncing store data on app launch

To sync data when your app launches or becomes active, you can listen to its scene phase change:

```swift
@main
struct MyApp: App {

    @StateObject
    private var context = StoreContext()

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .onChange(of: scenePhase, perform: syncStoreData)
        }
    }
}

private extension MyApp {

    func syncStoreData(for phase: ScenePhase) {
        guard phase == .active else { return }
        let ids = ["com.your-app.productid"]
        let service = StandardStoreService(productIds: ids)
        Task {
            try await storeService.syncStoreData(to: context)
        }
    }
}
```

You can inject the context as an `EnvironmentObject` to make the global state available to the entire app.



## StoreKit configuration files

StoreKitPlus is just a small layer on top of StoreKit, which means that all the amazing tools provided by Xcode works as expected. 

For instance, StoreKit configuration files work just like when you just use the native StoreKit framework.
