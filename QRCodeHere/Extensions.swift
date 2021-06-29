//
//  Extensions.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 25/12/2019.
//  Copyright © 2019 Abdullah Alhaider. All rights reserved.
//

import Foundation
import SwiftUI

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}

extension String {
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    
    /// Returns a black and white QR code for this string (self).
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = self.data(using: .utf8)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        
        let qrTransform = CGAffineTransform(scaleX: 20, y: 20)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
    
    /// Creates QR code NSImage from a string
    func generateQRCode(with color: NSColor? = nil, logo: NSImage? = nil) -> NSImage? {
        var image = self.qrImage
        if let color = color {
            image = image?.tinted(using: color)
        }
        if let customLogo = logo {
            image = image?.combined(with: CIImage(cgImage: customLogo.cgImage!))
        }
        return image?.asNSImage
    }
}

extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)

        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }
}

extension CIImage {
    
    var asNSImage: NSImage {
        let nsBitmapImageRep = NSBitmapImageRep(ciImage: self)
        let nsImage = NSImage(size: nsBitmapImageRep.size)
        nsImage.addRepresentation(nsBitmapImageRep)
        return nsImage
    }
    
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
}

extension CIImage {
    
    /// Applies the given color as a tint color.
    func tinted(using color: NSColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(
            // X value
            translationX: extent.midX - (image.extent.size.width / 4),
            // Y value
            y: extent.midY - (image.extent.size.height / 4)
        )
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
}
