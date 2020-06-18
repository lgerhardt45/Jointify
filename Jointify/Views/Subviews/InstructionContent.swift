//
//  InstructionContent.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionContent
struct InstructionContent: View {
    
    // MARK: Body
    var body: some View {
        VStack {
            // Mocking with "llorem ipsum"
            InstructionBulletPoint(number: 1)
            InstructionBulletPoint(number: 2)
        }
        
    }
}

// MARK: - InstructionBulletPoint
private struct InstructionBulletPoint: View {
    
    // MARK: Constants
    public enum Constants {
        static let lloremIpsum = "Lorem ipsum dolor sit amet"
    }
    
    // MARK: Stored Instance Properties
    let number: Int
    
    // MARK: Body
    var body: some View {
        HStack(alignment: .top) {
            Text("\(number).")
            .fontWeight(.light)
            .font(.system(size:18))
            Text(Constants.lloremIpsum)
            .fontWeight(.light)
            .font(.system(size:18))
            
        }
        .padding(.horizontal, 32.0)
    }
}
