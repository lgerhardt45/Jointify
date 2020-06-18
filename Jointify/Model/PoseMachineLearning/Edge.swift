//
//  File.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 15.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation

// MARK: - Edge
/// A structure used to describe a parent-child relationship between two joints.
struct Edge {
    
    // MARK: Stored Instance Properties
    let from: JointName
    let towards: JointName
    let index: Int
    
}
