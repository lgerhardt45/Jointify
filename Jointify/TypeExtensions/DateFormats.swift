//
//  DateExtension.swift
//  Jointify
//
//  Created by Annalena Feix on 23.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation

//MARK: -DateFormats
struct DateFormats {
    
    // Adapted from https://www.ralfebert.de/ios/swift-dateformatter-datumsangaben-formatieren/
    static var dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static var timeOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    
}

extension DefaultStringInterpolation {
    
    mutating func appendInterpolation(_ value: Date, formatter: DateFormatter) {
        self.appendInterpolation(formatter.string(from: value))
    }
    
}
