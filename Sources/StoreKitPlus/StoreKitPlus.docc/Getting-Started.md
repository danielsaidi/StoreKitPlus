# Getting Started

StoreKitPlus is a Swift-based library that adds extra functionality for working with StoreKit 2, like extensions, observable state, store services, etc.

StoreKitPlus builds on the great foundation that is provided by StoreKit 2 and just aims to make it easier to use StoreKit 2 in e.g. SwiftUI. 



## Getting products

To get products from StoreKit 2, you can use the `Product.products` api:

```swift
let productIds = ["com.your-app.productid"]
let products = try await Product.products(for: productIds)
```

However, if you need to fetch products in an abstract way, for instance if you need to mock this functionality in unit tests, inject additional functionality, etc., you can use the StoreKitPlus ``StoreService``, which has a ``StoreService/getProducts()`` function:

```swift
let productIds = ["com.your-app.productid"]
let products = try await service.getProducts()
```

The ``StandardStoreService`` service implementation communicates directly with StoreKit and syncs the result to a provided, observable ``StoreContext``. Read more on this context further down.



## Purchasing products

To purchase products with StoreKit 2, you can use the `Product.purchase` api:

```swift
let result = try await product.purchase()
switch result {
    case .success(let result): try await handleTransaction(result)
    case .pending: break
    case .userCancelled: break
    @unknown default: break
}
return result
```

However, if you need to purchase products in an abstract way, as described abovethe StoreKitPlus ``StoreService`` protocol has a ``StoreService/purchase(_:)`` function:

```swift
let result = try await service.purchase(product)
```

The ``StandardStoreService`` service implementation communicates directly with StoreKit and syncs the result to a provided, observable ``StoreContext``. Read more on this context further down.



## Restoring purchases

To restore purchase with StoreKit 2, you can use the `Transaction.latest(for:)` api and verify each transaction to see that it's purchased, not expired and not revoked.

This involves a bunch of steps, which makes the operation pretty complicated. To simplify, you can use the ``StoreService/restorePurchases()`` function:

```swift
try await service.restorePurchases()
```

The ``StandardStoreService`` service implementation communicates directly with StoreKit and syncs the result to a provided, observable ``StoreContext``. Read more on this context further down.



## Syncing store data

To perform a full product information sync with StoreKit 2, you can fetch products and transactions from StoreKit.

This involves a bunch of steps, which makes the operation pretty complicated. To simplify, you can use the ``StoreService/syncStoreData()`` function:

```swift
try await service.syncStoreData()
```

The ``StandardStoreService`` service implementation communicates directly with StoreKit and syncs the result to a provided, observable ``StoreContext``. Read more on this context further down.



## Observable state

StoreKitPlus has an observable ``StoreContext`` that can be used to observe the store state for a certain app.

```swift
let productIds = ["com.your-app.productid"]
let context = StoreContext()
let service = StandardStoreService(
    productIds: productIds,
    context: context
)
```

The context lets you keep track of available and purchased products, and can be injected into a ``StandardStoreService`` to keep track of changes as the user uses the service to communicate with StoreKit.



## Local products

If you want to have a local representation of your StoreKit product collection, you can use the ``ProductRepresentable`` protocol.

The protocol is just an easy way to provide identifiable product types, that can be matched with the real product IDs, for instance:

```swift
enum MyProduct: CaseIterable, String, ProductRepresentable {

    case premiumMonthly = "com.myapp.products.premium.monthly"
    case premiumYearly = "com.myapp.products.premium.yearly"

    var id: String { rawValue }
}
```

You can now use this collection to initialize a standard store service:

```swift
let products = MyProduct.allCases
let context = StoreContext()
let service = StandardStoreService(
    products: products,
    context: context
)
```

You can also match any product collection with a context's purchased product IDs:

```swift
let products = MyProduct.allCases
let context = StoreContext()
let purchased = products.purchased(in: context)
```

However, some operations require that you provide a real StoreKit `Product`. 
