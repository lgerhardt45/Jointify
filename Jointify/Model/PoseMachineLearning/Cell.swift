//
//  Cell.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 17.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation

// MARK: - Cell
/// A structure that defines the coordinates of an index used to query the PoseNet model outputs.
///
/// The PoseNet outputs are arranged in grid. Each cell in the grid corresponds
/// to a square region of pixels where each side is `outputStride` pixels of the input image.
struct Cell {
    
    // MARK: Stored Type Properties
    static var zero: Cell {
        return Cell(0, 0)
    }
    
    // MARK: Stored Instance Properties
    let yIndex: Int
    let xIndex: Int
    
    // MARK: Initializers
    init(_ yIndex: Int, _ xIndex: Int) {
        self.yIndex = yIndex
        self.xIndex = xIndex
    }
}
