//
//  Watermark+ViewModifier.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 05/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct Watermark: ViewModifier {
    var text: String?
    
    func body(content: Content) -> some View {
        if let text = text {
            ZStack {
                Color.white
                VStack {
                    content
                        .padding(.top, 20)
                    Text(text)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(5)
                        .padding(.bottom, 10)
                        .background(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        } else {
            content
        }
    }
}

extension View {
    func watermarked(with text: String?) -> some View {
        self.modifier(Watermark(text: text))
    }
}

