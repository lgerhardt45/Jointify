//
//  Measurement.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 14.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation
import UIKit

// MARK: - Measurement
struct Measurement: Codable, Identifiable {
    
    // MARK: Stored Instance Properties
    let date: Date
    let minROMFrame: MeasurementFrame
    let maxROMFrame: MeasurementFrame
    
    let bodyHalf: BodyHalf = .lower
    let jointName: JointName = .leftKnee
    let side: Side = .left
    
    // swiftlint:disable:next identifier_name
    var id: UUID = UUID()
    // MARK: Computed Instance Properties
    var minROMValue: Float {
        return minROMFrame.degree
    }
    var maxROM: Float {
        return maxROMFrame.degree
    }
    
    // MARK: Initializers
    init(date: Date, minROMFrame: MeasurementFrame, maxROMFrame: MeasurementFrame) {
        self.date = date
        self.minROMFrame = minROMFrame
        self.maxROMFrame = maxROMFrame
    }
    
    // TODO: remove when proper check for failing to create an instance is setup
    /// creates a mock instance
    init() {
        self.date = Date()
        self.minROMFrame = MeasurementFrame(degree: 0, image: UIImage(named: "LogoMitText")!)
        self.maxROMFrame = MeasurementFrame(degree: 0, image: UIImage(named: "LogoMitText")!)
    }
}
