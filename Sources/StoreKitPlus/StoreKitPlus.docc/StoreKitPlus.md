# ``StoreKitPlus``

StoreKitPlus adds extra functionality for working with StoreKit 2, like extensions, observable state, services, etc.


## Overview

![StoreKitPlus logo](Logo.png)

StoreKitPlus has an observable ``StoreContext`` that lets you observe store state, service protocols and classes that let you fetch, purchase and sync products, as well as a ``ProductRepresentable`` protocol that lets you add a local product representation to your app.

StoreKitPlus supports `iOS 15`, `macOS 12`, `tvOS 15` and `watchOS 8`.



## Installation

StoreKitPlus can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/StoreKitPlus.git
```

You can also clone the repository and build the library locally.



## Getting started

The <doc:Getting-Started> article has a guide to help you get started with StoreKitPlus.



## Repository

For more information, source code, and to report issues, sponsor the project etc., visit the [project repository](https://github.com/danielsaidi/StoreKitPlus).



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.



## License

StoreKitPlus is available under the MIT license.



## Topics

### Articles

- <doc:Getting-Started>

### Foundation

- ``StoreContext``

### Products

- ``ProductID``
- ``ProductRepresentable``

### Services

- ``StandardStoreProductService``
- ``StandardStorePurchaseService``
- ``StandardStoreService``
- ``StoreProductService``
- ``StorePurchaseService``
- ``StoreSyncService``
- ``StoreService``
- ``StoreServiceError``

### Validation

- ``ValidatableTransaction``

