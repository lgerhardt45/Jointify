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
    
    // MARK: Computed Properties
    private var fractionDone: Double {
        return total == 0 ? 0 : Double(currentProgress) / Double(total)
    }
    
    private var barProgress: CGFloat {
        return CGFloat(fractionDone) * maxWidth
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
                    .foregroundColor(barProgress < 0.9 * maxWidth ? .blue : .green)
                    .frame(
                        width: barProgress <= self.maxWidth ? barProgress : self.maxWidth,
                        height: self.height)
                
            }.padding()
            
            Text("\(Int(fractionDone * 100))% done")
            
        }
        
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(currentProgress: .constant(9), total: .constant(10), maxWidth: 150, height: 20)
    }
}
