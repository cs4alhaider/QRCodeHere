//
//  SupportDeveloperView.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 30/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

@available(macOS 11.0, *)
struct SupportDeveloperView: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        Menu {
            ForEach(store.allProducts) { product in
                Button("\(product.title) - \(product.price)") {
                    store.purchaseProduct(product)
                }
            }
        } label: {
            Text("😍 Suuport me")
        }
        .onAppear {
            store.start()
        }
    }
}

@available(macOS 11.0, *)
struct SupportDeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        SupportDeveloperView()
    }
}
