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
    
    // MARK: Binding Instance Properties
    @Binding var showVideoPickerSheet: Bool
    
    // MARK: Body
    var body: some View {
        VStack {
            Text("Instructions")
                .font(.largeTitle)
            
            Spacer().frame(height: 20)
            
            // Mocking with "llorem ipsum"
            InstructionBulletPoint(number: 1)
            InstructionBulletPoint(number: 2)
            
            Spacer().frame(height: 50)
            
            DefaultButton(action: {
                // on pressing button, the sheet (see below) opens
                self.showVideoPickerSheet = true
            }) {
                Text("Confirm")
            }
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
            Text(Constants.lloremIpsum)
        }
        .padding(.horizontal, 32.0)
    }
}
