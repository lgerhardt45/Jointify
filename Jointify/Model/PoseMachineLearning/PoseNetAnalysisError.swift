//
//  PoseNetAnalysisError.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 02.07.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation

// MARK: - PoseNetAnalysisError
enum PoseNetAnalysisError: Error {
    case notEnoughFrames
    case acceptanceCriteriaFailed
}
