//
//  Constent+String.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 12/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Foundation

extension String {
    
    enum URLValue: String {
        case githubRepo = "https://github.com/cs4alhaider/QRCodeHere"
        case appStoreReviewLink = "https://apps.apple.com/app/id1577042983?action=write-review"
        case appStorePage = "https://apps.apple.com/app/id1577042983"
        case abdullahAppStorePage = "https://apps.apple.com/us/developer/abdullah-alhaider/id1332762194"
    }
    
    static func stringURL(_ forValue: URLValue) -> String {
        forValue.rawValue
    }
}
