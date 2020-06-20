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
    
    let bodyHalf: BodyHalf = .lower
    let jointName: JointName = .leftKnee
    let side: Side = .left
    
    // MARK: Computed Instance Properties
    var minROM: Float {
        return frames.map({$0.degree}).min() ?? 0
    }
    var maxROM: Float {
        return frames.map({$0.degree}).max() ?? 0
    }
    
    // MARK: Initializers
    init(date: Date, videoUrl: NSURL?, frames: [MeasurementFrame]) {
        self.date = date
        self.videoUrl = videoUrl
        self.frames = frames
    }
    
    /// creates a mock instance
    init() {
        self.date = Date()
        self.videoUrl = nil
        self.frames = []
    }
}
