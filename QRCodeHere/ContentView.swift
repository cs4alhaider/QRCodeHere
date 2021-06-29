//
//  ContentView.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 22/12/2019.
//  Copyright © 2019 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var text = ""

    var qrImage: NSImage? { text.generateQRCode() }
    
    let pasteboard: NSPasteboard = .general
    
    var pasteboardString: String {
        get { return pasteboard.string(forType: .string) ?? "" }
        set { pasteboard.setString(newValue, forType: .string) }
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Made with 💙 by ")
                            +
                            Text("@cs4alhaider")
                                .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    .onTapGesture(perform: openTwitter)
                    
                    HStack {
                        Spacer()

                        if let qrImage = qrImage {
                            Image(nsImage: qrImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280, height: 280, alignment: .center)
                                .padding(.bottom, 25)
                        } else {
                            Text("The text is too large to fit in a QR code. Try making it shorter.")
                                .frame(width: 280, height: 280)
                        }

                        Spacer()
                    }
                }
                
                Section {
                    Text("Start typing your text, URL to generate the QR code..")
                        .multilineTextAlignment(.center)
                        .lineLimit(0)
                    HStack {
                        TextField("Enter your text here", text: $text)
                        if !self.pasteboardString.isEmpty {
                            Button("Paste", action: appendCopidString)
                        }
                    }
                }
                .frame(minWidth: 335)
            }
        }
        .padding(35)
    }
    
    private func appendCopidString() {
        self.text = pasteboardString
    }
    
    private func openTwitter() {
        let url: URL = "https://twitter.com/cs4alhaider"
        NSWorkspace.shared.open(url)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
