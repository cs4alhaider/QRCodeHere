//
//  Constent+CGFloat.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 08/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Foundation

extension CGFloat {
    
    enum FrameValue: CGFloat {
        /// Value for QR code width and height
        case qrCodeView = 280
    }
    
    static func frame(_ forValue: FrameValue) -> CGFloat {
        forValue.rawValue
    }
}
