//
//  Store.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 27/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import StoreKit
import Combine

class Store: NSObject, ObservableObject {
    
    @Published var allProducts: [Product] = []
    
    @Published var fetchingProductsInProgress = false
    @Published var buyingProductInProgress = false
    
    static let shared = Store()
    
    private lazy var allProductsIDs = ProductType.all
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts: [SKProduct] = []
    private var fetchCompletionHandler: (([SKProduct]) -> Void)?
    private var purchaseCompletionHandler: ((SKPaymentTransaction?) -> Void)?
    private (set) var completedPurchases: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.allProducts.indices.forEach({
                    self.allProducts[$0].isLocked = !self.completedPurchases.contains(self.allProducts[$0].productIdentifier)
                })
            }
        }
    }
    
    private override init() {
        super.init()
        // start()
    }
    
    func start() {
        fetchingProductsInProgress = true
        fetchProducts { products in
            self.fetchingProductsInProgress = true
            self.allProducts = products.map { Product(product: $0) }.sorted(by: \.priceNumber, order: .increasing)
        }
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping (([SKProduct]) -> Void)) {
        guard productsRequest == nil else { return }
        fetchCompletionHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: allProductsIDs)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping (SKPaymentTransaction?) -> Void) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension Store {
    
    func product(for identifer: String) -> SKProduct? {
        fetchedProducts.first(where: { $0.productIdentifier == identifer })
    }
    
    func purchaseProduct(_ product: SKProduct) {
        buyingProductInProgress = true
        startObservingPaymentQueue()
        buy(product) { transaction in
            self.buyingProductInProgress = false
            if let transaction = transaction {
                print(transaction)
            }
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension Store: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
}

extension Store: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Cound not load the products!")
            if !invalidProducts.isEmpty {
                print("Invalid products found! -> \(invalidProducts)")
            }
            productsRequest = nil
            return
        }
        
        // Cache the fetched products
        fetchedProducts = loadedProducts
        
        // Notify anyone waiting on the product load
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}

extension Store {
    enum ProductType: CaseIterable {
        case smallSupport
        case midSupport
        case bigSupport
        
        var productId: String {
            switch self {
            case .smallSupport:
                return "net.alhaider.QRCodeHere.store.support.smallSupport"
            case .midSupport:
                return "net.alhaider.QRCodeHere.store.support.midSupport"
            case .bigSupport:
                return "net.alhaider.QRCodeHere.store.support.bigSupport"
            }
        }
        
        var title: String {
            "Loading..." // It should come from Apple protal
        }
        
        static var all: Set<String> {
            [
                "net.alhaider.QRCodeHere.store.support.smallSupport",
                "net.alhaider.QRCodeHere.store.support.midSupport",
                "net.alhaider.QRCodeHere.store.support.bigSupport"
            ]
        }
    }
}

extension Store {
    enum Error: Swift.Error {
        case paymentError(String)
        init(_ string: String) {
            self = .paymentError(string)
        }
    }
}
