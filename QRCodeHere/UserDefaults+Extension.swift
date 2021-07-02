//
//  UserDefaults+Extension.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 02/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Keys: String {
        case qrCodeContent = "UserDefaults.Keys.QR_CODE_CONTENT"
    }
    
    // Adding backward compatibility for old macOS since @AppStorage requires macOS v11
    
    func set(_ value: Any?, forKey key: Keys) {
        set(value, forKey: key.rawValue)
    }
    
    func value(forKey key: Keys) -> Any? {
        value(forKey: key.rawValue)
    }
}
