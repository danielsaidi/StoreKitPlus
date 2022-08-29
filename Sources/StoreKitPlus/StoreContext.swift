//
//  StoreContext.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This class can be used to manage store information in a way
 that makes it observable.

 You can use a ``StandardStoreService`` to sync product info
 with this context, which will update the ``products`` array
 with matching products.

 Since a StoreKit `Product` is not `Codable`, the ``products``
 array is not permanently persisted. This means that it will
 reset when the app is restarted. Due to this, there is also
 a ``productIds`` property that is permanently persisted. It
 gives you the option to map ``productIds`` to local product
 representations whenever the app can't access StoreKit.

 However, a StoreKit `Product` instance is needed to perform
 a purchase. If the app fails to fetch products, e.g. if the
 app is offline, you should show a spinner or an error alert
 to inform users that product information can't be retrieved.
 */
public class StoreContext: ObservableObject {

    /**
     Create a context instance.

     - Parameters:
       - productIds: An optional list of initial product IDs to use if no IDs have been persisted yet.
     */
    public init(productIds: [String] = []) {
        products = []
        self.productIds = persistedProductIds.isEmpty ? productIds : persistedProductIds
        purchasedProductIds = persistedPurchasedProductIds
    }
    
    /**
     A list of available products that have been synced with
     the context.

     You can use this property to keep track of the products
     that have been fetched from StoreKit.
     
     Since `Product` isn't `Codable`, this property can't be
     persisted. It must be re-fetched when the app starts.
     */
    @Published
    public var products: [Product] {
        didSet { productIds = products.map { $0.id} }
    }
    
    /**
     The IDs of available product that have been synced with
     the context with the ``products`` property.

     Unlike the non-persisted ``products``, this property is
     persisted, which means that you can map a local product
     collection to these IDs, to present product information
     even if the StoreKit request fails.
     */
    @Published
    public internal(set) var productIds: [String] = [] {
        willSet { persistedProductIds = newValue }
    }
    
    /**
     An array of active purchase transactions that have been
     synced with the context.

     You can use this property to keep track of the products
     that have been purchased by the user.

     Since `Transaction` isn't `Codable` this property can't
     be persisted. It must be re-fetched when the app starts.
     */
    public var purchaseTransactions: [Transaction] = [] {
        didSet { purchasedProductIds = purchaseTransactions.map { $0.productID } }
    }

    /**
     The IDs of purchased product that have been synced with
     the context using the ``purchaseTransactions`` property.

     Unlike the non-persisted ``purchaseTransactions``, this
     property is persisted, which means that you can use the
     property to keep track of purchased products even if an
     app can't access the StoreKit backend.
     */
    @Published
    public internal(set) var purchasedProductIds: [String] = [] {
        willSet { persistedPurchasedProductIds = newValue }
    }
    
    
    // MARK: - Persisted Properties
    
    @Persisted(key: key("productIds"), defaultValue: [])
    private var persistedProductIds: [String]
    
    @Persisted(key: key("purchasedProductIds"), defaultValue: [])
    private var persistedPurchasedProductIds: [String]
}

private extension StoreContext {
    
    static func key(_ name: String) -> String { "com.danielsaidi.storekitplus.\(name)" }
}
