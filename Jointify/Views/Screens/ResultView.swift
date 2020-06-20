//
//  ResultView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import MessageUI

// MARK: - ResultView
struct ResultView: View {
    
    // MARK: State Instance Properties
    // Home button
    @State private var homeButtonPressed: Bool = false
    // Report button
    @State private var isShowingMailView: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>?

    // MARK: Stored Instance Properties
    let measurement: Measurement
    let mockedPreviousMinValue: Int = -45
    let mockedPreviousMaxValue: Int = 80
    
    // MARK: Computed Instance Properties
    let canSendMail: Bool = MFMailComposeViewController.canSendMail()
    
    let possibleMailLabel = HStack {
        Image(systemName: "envelope")
        Text("Report")
    }
    let notPossibleMailLabel = HStack {
        Image(systemName: "bolt")
        Text("Can't send mail")
    }
    
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
                            ResultValues(valueType: "Max Value", value: Int(self.measurement.maxROM), showText: true)
                            ResultValues(valueType: "Min Value", value: Int(self.measurement.minROM), showText: true)
                        }
                        Text("Last Measurement (DD/MM/YY)")
                            .font(.system(size: 18))
                            .fontWeight(.light)
                        
                        HStack(spacing: 16.0) {
                            ResultValues(valueType: "Max Value", value: self.mockedPreviousMaxValue, showText: false)
                            ResultValues(valueType: "Min Value", value: self.mockedPreviousMinValue, showText: false)
                        }
                    }
                    
                }
                
                Spacer()
                
                DefaultButton(action: {
                    // create PDF and open Mail-app here
                }) {
                    Text("Send Mail").frame(width: geometry.size.width / 3.0)
                }
            }.padding(.bottom, 32)
        }
    }
}

// MARK: - Previews
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        ResultView(
            measurement: Measurement(
                date: Date(),
                videoUrl: nil,
                frames: []
            )
        )
    }
}
