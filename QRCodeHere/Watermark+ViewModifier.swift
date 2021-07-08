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
                VStack(spacing: 0) {
                    content
                    Text(text)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .background(Color.white)
                }
                .padding(5)
            }
            .frame(width: .frame(.qrCodeView))
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

