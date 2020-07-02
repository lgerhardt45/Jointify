//
//  ProgressBar.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 15.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ProgressBar
struct ProgressBar: View {
    
    // MARK: Binding Instance Properties
    @Binding var currentProgress: Int
    @Binding var total: Int
    @Binding var failed: Bool
    
    // MARK: Computed Properties
    private var fractionDone: Double {
        if !self.failed {
            return total == 0 ? 0 : Double(currentProgress) / Double(total)
        } else {
            return 1
        }
    }
    
    private var barProgress: CGFloat {
        return self.failed ? maxWidth : CGFloat(fractionDone) * maxWidth
    }
    
    private var stateColor: Color {
        if !self.failed {
            return barProgress < 0.9 * maxWidth ? .lightBlue : .green
        } else {
            return .red
        }
    }
        
    // MARK: Instance Properties
    let maxWidth: CGFloat
    let height: CGFloat
    
    // MARK: Body
    var body: some View {
        VStack {
            
            ZStack(alignment: .leading) {
                // background
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.gray)
                    .frame(width: self.maxWidth, height: self.height)
                
                // progress bar
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(stateColor)
                    .frame(
                        width: barProgress <= self.maxWidth ? barProgress : self.maxWidth,
                        height: self.height)
                
            }.padding()
            
            Text(self.failed ? "Analysis failed 😔" : "\(Int(fractionDone * 100))% done")
            
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(
            currentProgress: .constant(9),
            total: .constant(10),
            failed: .constant(true),
            maxWidth: 150,
            height: 20
        )
    }
}
