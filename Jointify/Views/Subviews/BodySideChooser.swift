//
//  BodySideChooser.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 27.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - BodySideChooser
struct BodySideChooser: View {
    
    // MARK: Binding Instance Properties
    @Binding var chosenSideIndex: Int
    
    // MARK: Stored Instance Properties
    let width: CGFloat
    
    // MARK: Computed Instance Properties^
    var leftLabel: Text {
        let label = Text("Left").foregroundColor(.lightBlue)
        return Int(chosenSideIndex) == 0 ? label.bold() : label
    }
    
    var rightLabel: Text {
        let label = Text("Right").foregroundColor(.lightBlue)
        return Int(chosenSideIndex) == 1 ? label.bold() : label
    }
    
    // MARK: Body
    var body: some View {
        
        Picker("Choose side", selection: $chosenSideIndex) {
            ForEach(0..<Side.allCases.count) { sideIndex in
                Text(Side.allCases[sideIndex].rawValue).tag(sideIndex)
            }
        }.pickerStyle(SegmentedPickerStyle())
            .frame(width: width)
    }
}

// MARK: - Previews
struct BodySideChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        BodySideChooser(chosenSideIndex: .constant(1), width: 250)
    }
}
