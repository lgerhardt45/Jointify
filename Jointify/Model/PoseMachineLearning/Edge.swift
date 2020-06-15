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
    let index: Int
    let parent: Joint.Name
    let child: Joint.Name
    
    // MARK: Initializers
    // TODO: Lukas: structs don't need initializers (when nothing happens in them)
    init(from parent: Joint.Name, to child: Joint.Name, index: Int) {
        self.index = index
        self.parent = parent
        self.child = child
    }
}
