# Release notes


## 0.3.1

This version fixes an async error that could cause purchases to update the context on a background thread. 



## 0.3

StoreKitPlus now uses Swift 5.9, which requires Xcode 15.

This version also adds support for visionOS, although the purchase operation doesn't work.

### ✨ Features

* `Product` has a new `products(for:)` that uses a product representable collection.
* `ProductRepresentable` has a new function to fetch all available products in a context.



## 0.2

This release breaks up the `StoreService` protocol into multiple protocols.

This is done to simplify implementing custom services, mocking in unit tests etc.

### ✨ Features

* `StandardProductService` is a new service that takes care of fetching products.
* `StandardPurchaseService` is a new service that takes care of purchasing products and restoring purchases.
* `StoreService` has been split up into three protocols: `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.
* `StoreContext` has a new `product(withId:)` function.

### 💡 Behavior changes

* `StoreService` now inherits `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.
* `StandardStoreService` now implements `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.
* `StandardStoreService` now uses nested service implementations to make its own logic easier to overview.



## 0.1

This is a first beta release of StoreKitPlus.

This version introduces a bunch of types that makes it easier to work with StoreKit in an abstract, protocol-driven way.

### ✨ Features

* `StoreContext` is a new, observable type.
* `StoreService` is a new protocol for comunicating with StoreKit.
* `StandardStoreService` is a new class for comunicating with StoreKit.
* `ProductRepresentable` is a new protocol for providing local products.
* `ValidatableTransaction` is a new protocol for transaction validation.
