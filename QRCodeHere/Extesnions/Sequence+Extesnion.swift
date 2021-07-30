//
//  Sequence+Extesnion.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 30/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import Foundation

enum SortOrder {
    case increasing, decreasing
}

extension Sequence {
    
    func sorted<Value: Comparable>(by keyPath: KeyPath<Self.Element, Value>, order: SortOrder = .increasing) -> [Self.Element] {
        switch order {
        case .increasing:
            return self.sorted(by: { $0[keyPath: keyPath]  <  $1[keyPath: keyPath] })
        case .decreasing:
            return self.sorted(by: { $0[keyPath: keyPath]  >  $1[keyPath: keyPath] })
        }
    }
}
