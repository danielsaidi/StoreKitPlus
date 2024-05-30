//
//  StoreContext.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This observable class can manage store-based information
/// in a way that makes it observable.
///
/// You can use the ``StandardStoreService`` to sync product
/// info with this context, which will update the ``products``
/// array with matching products.
///
/// Since StoreKit `Product` isn't `Codable`, the ``products``
/// array is not permanently persisted, which means that the
/// property will reset when the app is restarted.
///
/// Due to this, there's also a ``productIds`` property that
/// is permanently persisted. It gives you the option to map
/// ``productIds`` to local product representations whenever
/// the app can't access StoreKit.
///
/// However, a StoreKit `Product` value is needed to perform
/// a purchase. If your app fails to fetch products, e.g. if
/// it's offline, you should show a spinner or an alert that
/// informs your users that your products can't be retrieved.
public class StoreContext: ObservableObject {

    /// Create a context instance.
    ///
    /// - Parameters:
    ///   - productIds: An optional list of initial product IDs to use if no IDs have been persisted yet.
    public init(productIds: [String] = []) {
        products = []
        self.productIds = persistedProductIds.isEmpty ? productIds : persistedProductIds
        purchasedProductIds = persistedPurchasedProductIds
    }
    
    /// A list of synced products.
    ///
    /// You can use this property to keep track of a product
    /// collection that has been fetched from StoreKit.
    ///
    /// Since `Product` isn't `Codable`, this property can't
    /// be persisted and must be reloaded on app launch.
    @Published
    public var products: [Product] {
        didSet { productIds = products.map { $0.id} }
    }

    /// A list of synced products IDs.
    ///
    /// You can use this property to keep track of a product
    /// collection that has been fetched from StoreKit.
    ///
    /// This property is persisted, which means that you can
    /// map these IDs to a local product representation when
    /// a StoreKit request fails.
    @Published
    public internal(set) var productIds: [String] = [] {
        willSet { persistedProductIds = newValue }
    }
    
    /// A list of active purchase transactions.
    ///
    /// You can use this property to keep track of purchased
    /// products that has been fetched from StoreKit.
    ///
    /// Since `Transaction` isn't `Codable` this property is
    /// not persisted and must be reloaded on app launch.
    public var purchaseTransactions: [Transaction] = [] {
        didSet { purchasedProductIds = purchaseTransactions.map { $0.productID } }
    }

    /// A list of purchased product IDs.
    ///
    /// You can use this property to keep track of purchased
    /// products that has been fetched from StoreKit.
    ///
    /// This property is persisted, which means that you can
    /// map these IDs to a local product representation when
    /// a StoreKit request fails. 
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
