//
//  ViewModel.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 30/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    let pasteboard: NSPasteboard = .general
    let defaults = UserDefaults.standard
    
    @Published var text = ""
    @Published var addWatermark = false
    @Published var watermark = ""
    
    var qrImage: NSImage? {
        text.generateQRCode()
    }
    
    var pasteboardString: String {
        get { return pasteboard.string(forType: .string) ?? "" }
    }
    
    var qrCodeCurrentFrame: CGFloat {
        watermark.isEmpty ? .frame(.qrCodeView) : 320
    }
    
    
    func appendCopidString() {
        self.text = pasteboardString
    }
    
    func openGithub() {
        let url: String = .stringURL(.githubRepo)
        url.openURL()
    }
    
    func saveQRContent(_ newContent: String) {
        defaults.set(newContent, forKey: .qrCodeContent)
    }
    
    func saveWatermarkContent(_ newContent: String) {
        defaults.set(newContent, forKey: .watermarkContent)
    }
    
    func updateQRContent() {
        if let watermarkContent = defaults.value(forKey: .watermarkContent) as? String {
            watermark = watermarkContent
            addWatermark = false
        }
    }
    
    func toggleWatermark() {
        withAnimation(.easeInOut(duration: 0.2)) {
            addWatermark.toggle()
        }
    }
    
    func copy(_ value: String) {
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(value, forType: .string)
    }
    
    func image(from nsImage: NSImage) -> some View {
        Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(width: qrCodeCurrentFrame, height: qrCodeCurrentFrame)
            .watermarked(with: watermark.isEmpty ? nil : watermark)
            .frame(maxHeight: .frame(.qrCodeView))
    }
    
    /// Saves the generated QR code image in the temporary directory and creates an item provider for it.
    ///
    /// I chose the approach of saving the image to disk instead of creating the `NSItemProvider` directly using, say, `.init(item:typeIdentifyer:)`
    /// to allow the  image to be dragged to more places like Finder and Safari.
    /// - Returns: The item provider for the generated QR code image, or `nil` if any error occures (I haven't encountered any errors during my testing).
    func createQRDraggable() -> NSItemProvider? {
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
