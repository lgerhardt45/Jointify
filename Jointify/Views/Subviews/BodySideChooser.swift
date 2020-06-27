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
    @Binding var chosenSideIndex: Double
    
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
        
        // Slider
        HStack(spacing: 16) {
            // left button
            Button(action: {
                self.chosenSideIndex = 0.0
            }) {
                leftLabel.frame(width: width * 0.3)
            }
            
            // slider
            Slider(value: self.$chosenSideIndex, in: 0.0...1.0, step: 1)
                .accentColor(.gray)
                .padding(.horizontal, 2)
                .background(Capsule().foregroundColor(.gray)).onTapGesture(perform: {
                    if self.chosenSideIndex == 0.0 {
                        self.chosenSideIndex = 1.0
                    } else {
                        self.chosenSideIndex = 0.0
                    }
                })
            
            // right button
            Button(action: {
                self.chosenSideIndex = 1.0
            }) {
                rightLabel.frame(width: width * 0.3)
            }
            
        }.frame(width: width)
    }
}

// MARK: - Previews
struct BodySideChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        BodySideChooser(chosenSideIndex: .constant(0.0), width: 250)
    }
}
