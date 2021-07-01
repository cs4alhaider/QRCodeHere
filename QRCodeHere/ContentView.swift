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

                        if let qrImage = qrImage, let qrImageDraggable = createQRDraggable() {
                            Image(nsImage: qrImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280, height: 280, alignment: .center)
                                .padding(.bottom, 25)
                                .onDrag { qrImageDraggable }
                        } else {
                            Text("The text is too large to fit in a QR code.\nTry making it shorter.")
                                .foregroundColor(.secondary)
                                .frame(width: 280, height: 280)
                                .multilineTextAlignment(.center)
                                .border(Color.secondary, width: 1)
                                .padding(.bottom, 25)
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

    /// Saves the generated QR code image in the temporary directory and creates an item provider for it.
    ///
    /// I chose the approach of saving the image to disk instead of creating the `NSItemProvider` directly using, say, `.init(item:typeIdentifyer:)`
    /// to allow the  image to be dragged to more places like Finder and Safari.
    /// - Returns: The item provider for the generated QR code image, or `nil` if any error occures (I haven't encountered any errors during my testing).
    private func createQRDraggable() -> NSItemProvider? {
        // The first representation is added in the `asNSImage` computed property of the `CIImage` extension.
        let imageRepresentation = qrImage?.representations.first as? NSBitmapImageRep

        // Get a PNG representation of the image.
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])

        // Define the URL to write the temporary QR code to.
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let filePath = temporaryDirectory.appendingPathComponent("QRCode.png")

        try? pngData?.write(to: filePath)

        let provider = NSItemProvider(contentsOf: filePath)

        return provider
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
