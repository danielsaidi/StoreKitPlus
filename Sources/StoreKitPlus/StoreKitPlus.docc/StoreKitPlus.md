# ``StoreKitPlus``

StoreKitPlus adds extra functionality for working with StoreKit 2, like extensions, observable state, store services, etc.


## Overview

![StoreKitPlus logo](Logo.png)

StoreKitPlus has an observable ``StoreContext`` that lets you observe store state, a ``StoreService`` protocol and a ``StandardStoreService`` implementation that simplifies fetching, purchasing and syncing products, as well as a ``ProductRepresentable`` protocol that lets you use local product representations in your app.


## Supported Platforms

StoreKitPlus supports `iOS 15`, `macOS 12`, `tvOS 15` and `watchOS 8`.



## Installation

The best way to add StoreKitPlus to your app is to use the Swift Package Manager.

```
https://github.com/danielsaidi/StoreKitPlus.git
```

StoreKitPlus also supports CocoaPods:

```
pod StoreKitPlus
```

You can also clone the repository and build the library locally.



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.

Note that type extensions are not included in this documentation.




## License

StoreKitPlus is available under the MIT license.



## Topics

### Articles

- <doc:Getting-Started>

### Foundation

- ``StoreContext``
- ``StoreService``
- ``StoreServiceError``
- ``StandardStoreService``

### Products

- ``ProductRepresentable``

### Validation

- ``ValidatableTransaction``

