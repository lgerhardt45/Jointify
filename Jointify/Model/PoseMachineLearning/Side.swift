//
//  Side.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 17.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import Foundation

enum Side: String, CustomStringConvertible {
    case left
    case right
    
    var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}
