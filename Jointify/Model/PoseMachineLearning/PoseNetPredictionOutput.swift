//
//  PoseNetPredictionOutput.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 29.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation
import SwiftUI

// MARK: - PoseNetPredictionOutput
struct PoseNetPredictionOutput: Identifiable {
    
    // MARK: Stored Instance Properties
    let id = UUID()
    let degree: Float
    let image: CGImage
    let outputQualityAcceptable: Bool
    let pose: Pose
    let originalFrameSize: CGSize
}
