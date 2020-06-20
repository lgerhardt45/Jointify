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

// MARK: - MeasurementSheetPDFWriter
class MeasurementSheetPDFWriter {
    
    // MARK: Stored Instance Properties
    let measurement: Measurement
    
    // MARK: Computed Instance Properties
    var side: Side {
        self.measurement.side
    }
    
    // MARK: Initializers
    init(measurement: Measurement) {
        self.measurement = measurement // my measurement is the one I got from you
    }
    
    // MARK: Instance Methods
    // methods that are available to others
    
    /// creates the relevant PDF (upper and lower) with the measurements written onto it
    func createPDF() { // whats the right Type of a PDF to return?
        
        //step 1: get template as UIImage
        guard let template: UIImage = loadTemplate() else {
            print("Template could not be loaded.")
            return
        }
        
        //step 2: locate writing position
        let writingPosition: CGPoint = locateWritingPosition()
        
        //step 3: write measurement on template
        guard let filledTemplate: UIImage = writeMeasurement(onto: template, at: writingPosition) else{
            print("Could not write on template.")
            return
        }
    }
    
    // MARK: Private Instance Methods
    // helper methods
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
    
    // checks on where the measurements on the specific document have to be written
    func locateWritingPosition() -> CGPoint {
        //writing position depends on body half, joint, side
        switch
        
        return CGPoint()
    }
    
    // writes measurement values in the right spot in the UIImage
    func writeMeasurement(onto image: UIImage, at point: CGPoint) -> UIImage? {
        
        return nil
    }
    
    /// converts UIImage to a PDF
    func exportToPDF(imageToConvert: UIImage) -> Data? {
        
        return nil
    }
}
