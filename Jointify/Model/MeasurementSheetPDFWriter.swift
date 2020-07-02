//
//  MeasurementSheetPDFWriter.swift
//  Jointify
//
//  Created by user175619 on 6/20/20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import PDFKit

// MARK: - PDFWriterError
enum PDFWriterError: Error {
    case writerError(String)
}

// MARK: - MeasurementSheetPDFWriter
class MeasurementSheetPDFWriter {
    
    // MARK: Constants
    enum Constants {
        // add fixed on values on respective canvas
        // left elbow
        static let leftElbowLeftNeutralNullPosition = CGPoint(x: 675, y: 520)
        static let leftElbowMiddleNeutralNullPosition = CGPoint(x: 725, y: 520) // TODO: richtig?
        static let leftElbowRightNeutralNullPosition = CGPoint(x: 775, y: 520) // TODO: richtig?
        static let leftElbowNeutralNullPositions = [
            Constants.leftElbowLeftNeutralNullPosition,
            Constants.leftElbowMiddleNeutralNullPosition,
            Constants.leftElbowRightNeutralNullPosition
        ]
        
        // right elbow
        static let rightElbowLeftNeutralNullPosition = CGPoint(x: 495, y: 520)
        static let rightElbowMiddleNeutralNullPosition = CGPoint(x: 545, y: 520) // TODO: richtig?
        static let rightElbowRightNeutralNullPosition = CGPoint(x: 595, y: 520) // TODO: richtig?
        static let rightElbowNeutralNullPositions = [
            Constants.rightElbowLeftNeutralNullPosition,
            Constants.rightElbowMiddleNeutralNullPosition,
            Constants.rightElbowRightNeutralNullPosition
        ]
        
        // left knee
        static let leftKneeLeftNeutralNullPosition = CGPoint(x: 660, y: 544)
        static let leftKneeMiddleNeutralNullPosition = CGPoint(x: 710, y: 544) // TODO: richtig?
        static let leftKneeRightNeutralNullPosition = CGPoint(x: 760, y: 544) // TODO: richtig?
        static let leftKneeNeutralNullPositions = [
            Constants.leftKneeLeftNeutralNullPosition,
            Constants.leftKneeMiddleNeutralNullPosition,
            Constants.leftKneeRightNeutralNullPosition
        ]
        
        // right knee
        static let rightKneeLeftNeutralNullPosition = CGPoint(x: 495, y: 544)
        static let rightKneeMiddleNeutralNullPosition = CGPoint(x: 545, y: 544) // TODO: richtig?
        static let rightKneeRightNeutralNullPosition = CGPoint(x: 595, y: 544) // TODO: richtig?
        static let rightKneeNeutralNullPositions = [
            Constants.rightKneeLeftNeutralNullPosition,
            Constants.rightKneeMiddleNeutralNullPosition,
            Constants.rightKneeRightNeutralNullPosition
        ]
    }
    
    // MARK: Stored Instance Properties
    let measurement: Measurement
    
    // MARK: Computed Instance Properties
    var side: Side {
        self.measurement.side
    }
    
    // MARK: Initializers
    init(measurement: Measurement) {
        self.measurement = measurement
    }
    
    // MARK: Instance Methods
    //  = methods that are available to others
    
    /// creates the relevant PDF (upper and lower) with the measurements written onto it
    func createPDF(completion: (Result<Data, PDFWriterError>) -> Void) {
        
        // step 1: get template as UIImage
        guard let template: UIImage = loadTemplate() else {
            completion(.failure(.writerError("Template could not be loaded.")))
            return
        }
        
        // step 2: locate writing position
        guard let writingPositions: [CGPoint] = locateWritingPosition() else {
            completion(.failure(.writerError("Could not determine writing position on the template")))
            return
        }
        
        // step 3: write measurement on template
        guard let filledTemplate: UIImage = writeMeasurement(onto: template, at: writingPositions) else {
            completion(.failure(.writerError("Could not write on template.")))
            return
        }
        
        guard let pdf: Data = exportToPDF(imageToConvert: filledTemplate) else {
            completion(.failure(.writerError("Could not create PDFPage from image")))
            return
        }
        
        completion(.success(pdf))
    }
    
    // MARK: Private Instance Methods
    //  = helper methods
    /// loads the correct image template for the body half (upper or lower)
    func loadTemplate() -> UIImage? {
        
        switch self.measurement.bodyHalf {
        case .lower:
            print("Lower template chosen")
            return UIImage(named: "lowerextremitiessheet")
        case .upper:
            print("Upper template chosen")
            return UIImage(named: "upperextremitiessheet")
        }
    }
    
    /// checks on where the measurements on the specific document have to be written
    func locateWritingPosition() -> [CGPoint]? {
        
        // writing position depends on body half, joint, side
        let supportedLowerJoints: [JointName] = [.leftKnee, .rightKnee]
        let supportedUpperJoints: [JointName] = [.leftElbow, .rightElbow]
                
        switch measurement.bodyHalf {
            
        case .lower:
            if !supportedLowerJoints.contains(measurement.jointName) {
                print("Joint \(measurement.jointName) not supported")
                return nil
            } else {
                switch measurement.jointName {
                    
                case .leftKnee:
                    print("Getting CGPoints for left Knee")
                    return Constants.leftKneeNeutralNullPositions
                case .rightKnee:
                    print("Getting CGPoints for right Knee")
                    return Constants.rightKneeNeutralNullPositions
                    
                default: return nil // will not happen
                    
                }
            }
            
        case .upper:
            if !supportedUpperJoints.contains(measurement.jointName) {
                print("Joint \(measurement.jointName) not supported")
                return nil
            } else {
                switch measurement.jointName {
                    
                case .leftElbow:
                    print("Getting CGPoint for left elbow")
                    return Constants.leftElbowNeutralNullPositions
                case .rightElbow:
                    print("Getting CGPoint for right elbow")
                    return Constants.rightElbowNeutralNullPositions
                    
                default: return nil // will not happen
                    
                }
            }
        }
    }
    
    /// writes measurement values in the right spot in the UIImage
    /// from https://stackoverflow.com/a/28907826
    func writeMeasurement(onto image: UIImage, at points: [CGPoint]) -> UIImage? {
        
        // TODO: Use "ROM-values" in Measurement here
        let minRom = String(Int(round(measurement.minROMFrame.degree)))
        let neutralRom = "0"
        let maxRom = String(Int(round(measurement.maxROMFrame.degree)))
        
        let textColor = UIColor.red
        let textFont = UIFont(name: "Helvetica Bold", size: 15)!
        
        let scale = UIScreen.main.scale
        
        // start the drawing environment
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes =
            [NSAttributedString.Key.font: textFont,
             NSAttributedString.Key.foregroundColor: textColor]
                as [NSAttributedString.Key: Any]
        // draw base template
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        // TODO: is this right (min = left value?)
        // TODO: check array length beforehand
        let minROMLeftRect = CGRect(origin: points[0], size: image.size)
        let neutralROMMiddleRect = CGRect(origin: points[1], size: image.size)
        let maxROMRightRect = CGRect(origin: points[2], size: image.size)
        
        minRom.draw(in: minROMLeftRect, withAttributes: textFontAttributes)
        neutralRom.draw(in: neutralROMMiddleRect, withAttributes: textFontAttributes)
        maxRom.draw(in: maxROMRightRect, withAttributes: textFontAttributes)
        
        // get final image from drawing environment
        let imageWithMeasurement = UIGraphicsGetImageFromCurrentImageContext()
        // finish drawing environment
        UIGraphicsEndImageContext()
        
        return imageWithMeasurement
    }
    
    /// converts UIImage to a PDF
    /// from https://stackoverflow.com/a/45001576
    func exportToPDF(imageToConvert: UIImage) -> Data? {
        // Create an empty PDF document
        let pdfDocument = PDFDocument()
        
        // Create a PDF page instance from your image
        guard let pdfPage = PDFPage(image: imageToConvert) else {
            return nil
        }
        
        // Insert the PDF page into your document
        pdfDocument.insert(pdfPage, at: 0)
        
        // Get the raw data of your PDF document
        return pdfDocument.dataRepresentation()
    }
}
