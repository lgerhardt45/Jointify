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
        VStack {

            Text("The video was analysed:")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            
            Spacer().frame(height: 50)
            
            VStack(spacing: 8.0) {
                Text("Your measurements:").font(.title)
                
                VStack {
                    HStack(spacing: 16.0) {
                        Text("Max value: \(measurement.maxROM)°")
                        Text("Min value: \(measurement.minROM)°")
                    }
                    HStack(spacing: 16.0) {
                        Text("previous: \(mockedPreviousMaxValue)°")
                            .foregroundColor(Color.gray)
                        Text("previous: \(mockedPreviousMinValue)°")
                            .foregroundColor(Color.gray)
                    }
                }
         
            }
            
            Spacer().frame(height: 50)
            
            VStack {
                // Home button
                DefaultButton(action: {
                    // back home
                }) {
                    Text("Do it again")
                }
                
                // Report button
                DefaultButton(
                    mode: canSendMail ? .enabled : .disabled,
                    action: {
                        self.isShowingMailView.toggle()
                }) {
                    self.canSendMail ? self.possibleMailLabel : self.notPossibleMailLabel
                }
                    
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result)
                }
                
            }.padding(.horizontal, 60)
        }
    }
}

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
