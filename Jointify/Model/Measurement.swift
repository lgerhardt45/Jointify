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
    var minROMValue: Int {
        return Int(round(minROMFrame.degree))
    }
    
    var maxROMValue: Int {
        return Int(round(maxROMFrame.degree))
    }
    
    var neutralNullKneeLeftValue: Int {
        return maxROMValue >= 180 ? maxROMValue - 180 : 0
    }

    var neutralNullKneeMiddleValue: Int {
        return maxROMValue >= 180 ? 0 : maxROMValue
    }
    
    var neutralNullKneeRightValue: Int {
        return 180 - minROMValue
    }
    
    // MARK: Initializers
    init(date: Date, minROMFrame: MeasurementFrame, maxROMFrame: MeasurementFrame) {
        self.date = date
        self.minROMFrame = minROMFrame
        self.maxROMFrame = maxROMFrame
    }
    
    /// creates a mock instance
    init() {
        self.date = Date()
        self.minROMFrame = MeasurementFrame(degree: 0, image: UIImage(named: "LogoMitText")!)
        self.maxROMFrame = MeasurementFrame(degree: 0, image: UIImage(named: "LogoMitText")!)
    }
}
