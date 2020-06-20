//
//  ResultView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ResultView
struct ResultView: View {
    
    // MARK: State Instance Properties
    @State private var createReportButtonPressed: Bool = false
    @State private var homeButtonPressed: Bool = false
    
    // MARK: Stored Instance Properties
    // TODO: change to Measurement
    let minValue: Int = -55
    let maxValue: Int = 90
    let previousMinValue: Int = -45
    let previousMaxValue: Int = 80
    
    // MARK: Body
    var body: some View {
        
        // GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            // Outer VStack
            VStack(spacing: 16) {
                LogoAndHeadlineView(headline: "Your Results", showLogo: true, height: geometry.size.height * 0.2)
                
                Spacer()
                
                // Content: Result Values
                VStack(spacing: 8.0) {
                    VStack {
                        
                        HStack(spacing: 16.0) {
                            ResultValues(valueType: "Max Value", value: self.maxValue, showText: true)
                            ResultValues(valueType: "Min Value", value: self.minValue, showText: true)
                        }
                        Text("Last Measurement (DD/MM/YY)")
                            .font(.system(size: 18))
                            .fontWeight(.light)
                        
                        HStack(spacing: 16.0) {
                            ResultValues(valueType: "Max Value", value: self.previousMaxValue, showText: false)
                            ResultValues(valueType: "Min Value", value: self.previousMinValue, showText: false)
                        }
                    }
                    
                }
                
                Spacer()
                
                DefaultButton(action: {
                    // create PDF and open Mail-app here
                }) {
                    Text("Send Mail").frame(width: geometry.size.width / 3.0)
                }
            }.padding(.bottom)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
