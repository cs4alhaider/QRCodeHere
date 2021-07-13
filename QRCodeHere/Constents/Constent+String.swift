//
//  Constent+String.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 12/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Foundation

extension String {
    
    enum staticURLs: StringLiteralType {
        case githubProject = "https://github.com/cs4alhaider/QRCodeHere"
    }
    
    static func url(_ forValue: staticURLs) -> StringLiteralType {
        forValue.rawValue
    }
}
