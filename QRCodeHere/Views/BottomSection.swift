//
//  BottomSection.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 30/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct BottomSection: View {
    var body: some View {
        Section {
            HStack {
                if #available(macOS 11.0, *) {
                    SupportDeveloperView()
                } else {
                    // Fallback on earlier versions
                }
                
                Button("Other Apps..") {
                    let url: String = .stringURL(.abdullahAppStorePage)
                    url.openURL()
                }
        
                Button("Review & Share..") {
                    let url: String = .stringURL(.appStoreReviewLink)
                    url.openURL()
                }
            }
            .font(.body)
        }
    }
}

struct BottomSection_Previews: PreviewProvider {
    static var previews: some View {
        BottomSection()
    }
}
