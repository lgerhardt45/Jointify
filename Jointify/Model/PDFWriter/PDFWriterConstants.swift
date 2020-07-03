//
//  File.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 03.07.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation
import UIKit

// MARK: - PDFWriterConstants
/// Fixed CGPoint values on the respective canvas used for drawing
enum PDFWriterConstants {
    
    // name
    static let namePosition = CGPoint(x: 215, y: 68)
    
    // date
    static let datePosition = CGPoint(x: 330, y: 117)
    
    // elbows
    static let elbowYPosition = 517
    // left elbow
    static let leftElbowLeftNeutralNullPosition = CGPoint(x: 675, y: PDFWriterConstants.elbowYPosition)
    static let leftElbowMiddleNeutralNullPosition = CGPoint(x: 735, y: PDFWriterConstants.elbowYPosition)
    static let leftElbowRightNeutralNullPosition = CGPoint(x: 800, y: PDFWriterConstants.elbowYPosition)
    static let leftElbowNeutralNullPositions = [
        PDFWriterConstants.leftElbowLeftNeutralNullPosition,
        PDFWriterConstants.leftElbowMiddleNeutralNullPosition,
        PDFWriterConstants.leftElbowRightNeutralNullPosition
    ]
    
    // right elbow
    static let rightElbowLeftNeutralNullPosition = CGPoint(x: 500, y: PDFWriterConstants.elbowYPosition)
    static let rightElbowMiddleNeutralNullPosition = CGPoint(x: 560, y: PDFWriterConstants.elbowYPosition)
    static let rightElbowRightNeutralNullPosition = CGPoint(x: 620, y: PDFWriterConstants.elbowYPosition)
    static let rightElbowNeutralNullPositions = [
        PDFWriterConstants.rightElbowLeftNeutralNullPosition,
        PDFWriterConstants.rightElbowMiddleNeutralNullPosition,
        PDFWriterConstants.rightElbowRightNeutralNullPosition
    ]
    
    // knees
    static let kneeYPosition = 542
    // left knee
    static let leftKneeLeftNeutralNullPosition = CGPoint(x: 655, y: PDFWriterConstants.kneeYPosition)
    static let leftKneeMiddleNeutralNullPosition = CGPoint(x: 710, y: PDFWriterConstants.kneeYPosition)
    static let leftKneeRightNeutralNullPosition = CGPoint(x: 760, y: PDFWriterConstants.kneeYPosition)
    static let leftKneeNeutralNullPositions = [
        PDFWriterConstants.leftKneeLeftNeutralNullPosition,
        PDFWriterConstants.leftKneeMiddleNeutralNullPosition,
        PDFWriterConstants.leftKneeRightNeutralNullPosition
    ]
    
    // right knee
    static let rightKneeLeftNeutralNullPosition = CGPoint(x: 495, y: PDFWriterConstants.kneeYPosition)
    static let rightKneeMiddleNeutralNullPosition = CGPoint(x: 550, y: PDFWriterConstants.kneeYPosition)
    static let rightKneeRightNeutralNullPosition = CGPoint(x: 605, y: PDFWriterConstants.kneeYPosition)
    static let rightKneeNeutralNullPositions = [
        PDFWriterConstants.rightKneeLeftNeutralNullPosition,
        PDFWriterConstants.rightKneeMiddleNeutralNullPosition,
        PDFWriterConstants.rightKneeRightNeutralNullPosition
    ]
}
