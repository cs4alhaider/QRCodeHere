//
//  Product.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 27/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import StoreKit

struct Product: Hashable, Identifiable {
    let id: UUID
    let productIdentifier, title, description: String
    let priceLocale: Locale
    let priceNumber: Double
    let imageName: String?
    let skProduct: SKProduct
    
    var price: String = ""
    var isLocked: Bool
    
    private lazy var priceFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = priceLocale
        return nf
    }()
    
    init(product: SKProduct, isLocked: Bool = true) {
        self.id = UUID()
        self.productIdentifier = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.isLocked = isLocked
        self.priceLocale = product.priceLocale
        self.priceNumber = Double(truncating: product.price)
        self.imageName = product.productIdentifier
        self.skProduct = product
        
        if isLocked {
            self.price = priceFormatter.string(from: product.price) ?? "N/A"
        }
    }
}
