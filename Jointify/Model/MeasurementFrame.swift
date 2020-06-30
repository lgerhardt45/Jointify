//
//  MeasurementFrame.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 12.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation
import UIKit

// MARK: - MeasurementFrame
struct MeasurementFrame: Hashable, Codable {
    
    // MARK: Stored Instance Properties
    let degree: Float
    let image: Data
    
    init(degree: Float, image: UIImage) {
        self.degree = degree
        if let imageData = image.pngData() {
            self.image = imageData
        } else {
            self.image = UIImage(systemName: "heart.fill")!.pngData()!
        }
    }
}
