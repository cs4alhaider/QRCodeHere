//
//  ContentView.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 22/12/2019.
//  Copyright © 2019 Abdullah Alhaider. All rights reserved.
//

import SwiftUI
import StoreKit
#warning("TO-DO: Maybe adding coreData to save old QR Code contnet?")

struct ContentView: View {
    
    let pasteboard: NSPasteboard = .general
    let defaults = UserDefaults.standard
    
    @State private var text = ""
    @State private var addWatermark = false
    @State private var watermark = ""
    
    var qrImage: NSImage? {
        text.generateQRCode()
    }
    
    var pasteboardString: String {
        get { return pasteboard.string(forType: .string) ?? "" }
    }
    
    var qrCodeCurrentFrame: CGFloat {
        watermark.isEmpty ? .frame(.qrCodeView) : 320
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Open sourced with 💙 at ")
                            +
                            Text("GitHub")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    .onTapGesture(perform: openGithub)
                    
                    HStack {
                        Spacer()
                        
                        if let qrImage = qrImage,
                           let qrImageDraggable = createQRDraggable() {
                            image(from: qrImage)
                                .padding(.bottom, 25)
                                .onDrag { qrImageDraggable }
                        } else {
                            Text("The text is too large to fit in a QR code.\nTry making it shorter.")
                                .foregroundColor(.secondary)
                                .frame(width: .frame(.qrCodeView), height: .frame(.qrCodeView))
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
                        TextField("Enter your text here", text: $text.onChange(saveQRContent))
                        if !self.pasteboardString.isEmpty {
                            Button("Paste", action: appendCopidString)
                        }
                    }
                    watermarkView
                }
                .frame(minWidth: 335)
                
                Section {
                    Divider()
                        .padding(.vertical)
                }
                
                BottomSection()
            }
            
            MenuView()
                .frame(width: 55)
                .offset(x: 38, y: -30)
        }
        .padding(35)
        .onAppear(perform: updateQRContent)
    }
    
    func image(from nsImage: NSImage) -> some View {
        Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(width: qrCodeCurrentFrame, height: qrCodeCurrentFrame)
            .watermarked(with: watermark.isEmpty ? nil : watermark)
            .frame(maxHeight: .frame(.qrCodeView))
    }
    
    var watermarkView: some View {
        Section {
            HStack {
                TextField("Enter your watermark here", text: $watermark.onChange(saveWatermarkContent))
                if !watermark.isEmpty {
                    Button("Remove watermark") {
                        watermark = ""
                        saveWatermarkContent("")
                    }
                }
            }
        }
    }
    
    private func appendCopidString() {
        self.text = pasteboardString
    }
    
    private func openGithub() {
        let url: URL = "https://github.com/cs4alhaider/QRCodeHere"
        NSWorkspace.shared.open(url)
    }
    
    private func saveQRContent(_ newContent: String) {
        defaults.set(newContent, forKey: .qrCodeContent)
    }
    
    private func saveWatermarkContent(_ newContent: String) {
        defaults.set(newContent, forKey: .watermarkContent)
    }
    
    private func updateQRContent() {
        if let watermarkContent = defaults.value(forKey: .watermarkContent) as? String {
            watermark = watermarkContent
            addWatermark = false
        }
    }
    
    private func toggleWatermark() {
        withAnimation(.easeInOut(duration: 0.2)) {
            addWatermark.toggle()
        }
    }
    
    private func copy(_ value: String) {
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(value, forType: .string)
    }
    
    /// Saves the generated QR code image in the temporary directory and creates an item provider for it.
    ///
    /// I chose the approach of saving the image to disk instead of creating the `NSItemProvider` directly using, say, `.init(item:typeIdentifyer:)`
    /// to allow the  image to be dragged to more places like Finder and Safari.
    /// - Returns: The item provider for the generated QR code image, or `nil` if any error occures (I haven't encountered any errors during my testing).
    private func createQRDraggable() -> NSItemProvider? {
        guard let qrImage = qrImage else { return nil }
        
        let imageView = image(from: qrImage)
        let dimension = CGFloat.frame(.qrCodeView)
        let size = CGSize(width: dimension, height: dimension)
        
        guard let image = imageView.rasterize(at: size) else { return nil }
        
        guard let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!) else { return nil }
        
        // Get a PNG representation of the image.
        let pngData = imageRepresentation.representation(using: .png, properties: [:])
        
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
