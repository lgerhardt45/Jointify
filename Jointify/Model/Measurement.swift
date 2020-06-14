//
//  Measurement.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 14.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation

// MARK: - Measurement
struct Measurement {
    
    // MARK: Stored Instance Properties
    let date: Date
    let videoUrl: NSURL?
    let frames: [MeasurementFrame]
    
    // MARK: Computed Instance Properties
    var minROM: Float {
        return 0 // search through `frames`
    }
    var maxROM: Float {
        return 0 // search through `frames`
    }
}
