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
enum PDFWriterConstants {
    // add fixed on values on respective canvas
    // left elbow
    static let leftElbowLeftNeutralNullPosition = CGPoint(x: 675, y: 520)
    static let leftElbowMiddleNeutralNullPosition = CGPoint(x: 725, y: 520) // TODO: richtig?
    static let leftElbowRightNeutralNullPosition = CGPoint(x: 775, y: 520) // TODO: richtig?
    static let leftElbowNeutralNullPositions = [
        PDFWriterConstants.leftElbowLeftNeutralNullPosition,
        PDFWriterConstants.leftElbowMiddleNeutralNullPosition,
        PDFWriterConstants.leftElbowRightNeutralNullPosition
    ]
    
    // right elbow
    static let rightElbowLeftNeutralNullPosition = CGPoint(x: 495, y: 520)
    static let rightElbowMiddleNeutralNullPosition = CGPoint(x: 545, y: 520) // TODO: richtig?
    static let rightElbowRightNeutralNullPosition = CGPoint(x: 595, y: 520) // TODO: richtig?
    static let rightElbowNeutralNullPositions = [
        PDFWriterConstants.rightElbowLeftNeutralNullPosition,
        PDFWriterConstants.rightElbowMiddleNeutralNullPosition,
        PDFWriterConstants.rightElbowRightNeutralNullPosition
    ]
    
    // left knee
    static let leftKneeLeftNeutralNullPosition = CGPoint(x: 660, y: 544)
    static let leftKneeMiddleNeutralNullPosition = CGPoint(x: 710, y: 544) // TODO: richtig?
    static let leftKneeRightNeutralNullPosition = CGPoint(x: 760, y: 544) // TODO: richtig?
    static let leftKneeNeutralNullPositions = [
        PDFWriterConstants.leftKneeLeftNeutralNullPosition,
        PDFWriterConstants.leftKneeMiddleNeutralNullPosition,
        PDFWriterConstants.leftKneeRightNeutralNullPosition
    ]
    
    // right knee
    static let rightKneeLeftNeutralNullPosition = CGPoint(x: 495, y: 544)
    static let rightKneeMiddleNeutralNullPosition = CGPoint(x: 545, y: 544) // TODO: richtig?
    static let rightKneeRightNeutralNullPosition = CGPoint(x: 595, y: 544) // TODO: richtig?
    static let rightKneeNeutralNullPositions = [
        PDFWriterConstants.rightKneeLeftNeutralNullPosition,
        PDFWriterConstants.rightKneeMiddleNeutralNullPosition,
        PDFWriterConstants.rightKneeRightNeutralNullPosition
    ]
}
