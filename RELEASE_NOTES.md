# Release notes

StoreKitPlus will use semver after 1.0. 

Until then, deprecated features may be removed in any minor version, and breaking changes introduced.



## 0.7

### ✨ Features

* `StoreService` now lets you pass in optional purchase options.



## 0.6

This version removes deprecated code and adjusts some service terminology.

### ‼️ Breaking Changes

This version updates `StoreService` by renaming `restorePurchases()` to `getValidProductTransations()`.

This should have been done in 0.4. As the function only returned transactions, this was very confusing.

By renaming it, we no longer risk calling it with the intention of restoring purchases, which it didn't do.

We can now use `syncStoreData(to:)` and `restorePurchases(syncWith:)` to perform the exact operation we want.

Since these changes involve protocol changes, the changes are breaking. They should hopefully be easy to fix.  



## 0.5

This version adds more utilities.

### ✨ Features

* `BasicProduct` is a new, lightweight product struct.
* `Product` has new ways of calculating yearly savings.



## 0.4

This version makes StoreKitPlus use Swift 6.

### ‼️ Important information

As a result of the Swift 6 transition, and due to data race problems, the store services no longer takes a context and keeps it in sync. This must be explicitly handled by the caller, for instance using the new context-based functions.

Furthermore, the service model is drastically simplified in this version. Instead of having multiple service types, `StoreService` handles it all.

### ✨ Features

* `StoreService` has new `.standard` shorthands.
* `StoreService` has new `context`-based function versions.
* `StandardStoreService` no longer accepts a context, and will no longer keep it in sync.

### 🗑️ Deprecations

* `StoreProductService` has been deprecated.
* `StorePurchaseService` has been deprecated.
* `StoreSyncService` has been deprecated.



## 0.3.2

### ✨ Features

* `StandardProductSerice` now lets you inject custom services, if needed.



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
