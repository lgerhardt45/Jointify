//
//  Record.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: Record
class Record {
   
    // MARK: Stored Instance Properties
    let date: Date
    let video: [UIImage]
    let minDegree: Int
    let maxDegree: Int
    
    // MARK: Initializers
    init(date: Date, video: [UIImage], minDegree: Int, maxDegree: Int) {
        self.date = date
        self.video = video
        self.minDegree = minDegree
        self.maxDegree = maxDegree
    }
}
