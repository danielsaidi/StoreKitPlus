# Release notes


## 0.2

This release breaks up the `StoreService` protocol into multiple protocols.

This is done to simplify implementing custom services, mocking in unit tests etc.

### ✨ Features

* `StoreService` has been split up into three protocols: `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.
* `StoreContext` has a new `product(withId:)` function.

### 💡 Behavior changes

* `StoreService` now inherits `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.
* `StandardStoreService` now implements `StoreProductService`, `StorePurchaseService` and `StoreSyncService`.


## 0.1

This is a first beta release of StoreKitPlus.

This version introduces a bunch of types that makes it easier to work with StoreKit in an abstract, protocol-driven way.

### ✨ Features

* `StoreContext` is a new, observable type.
* `StoreService` is a new protocol for comunicating with StoreKit.
* `StandardStoreService` is a new class for comunicating with StoreKit.
* `ProductRepresentable` is a new protocol for providing local products.
* `ValidatableTransaction` is a new protocol for transaction validation.
