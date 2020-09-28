//
//  JointChooser.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 28.09.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - BodySideChooser
struct JointChooser: View {
    
    // MARK: Binding Instance Properties
    // 0 referrs to knee, 1 referrs to shoulder
    @Binding var chosenJointIndex: Int
    
    // MARK: Stored Instance Properties
    let width: CGFloat
    
    // MARK: Computed Instance Properties^
    var leftLabel: Text {
        let label = Text("Knee").foregroundColor(.lightBlue)
        return Int(chosenJointIndex) == 0 ? label.bold() : label
    }
    
    var rightLabel: Text {
        let label = Text("Shoulder").foregroundColor(.lightBlue)
        return Int(chosenJointIndex) == 1 ? label.bold() : label
    }
    
    // MARK: Body
    var body: some View {
        
        Picker("Choose joint", selection: $chosenJointIndex) {
            ForEach(0..<JointCase.allCases.count) { sideIndex in
                Text(JointCase.allCases[sideIndex].rawValue).tag(sideIndex)
            }
        }.pickerStyle(SegmentedPickerStyle())
            .frame(width: width)
    }
}

// MARK: - Previews
struct JointChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        BodySideChooser(chosenSideIndex: .constant(1), width: 250)
    }
}
