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
    // Show InfoView
    @State private var showInfoView: Bool = false
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
            
            // Used to show InfoView over everything
            ZStack {
                
                // Outer VStack
                VStack(spacing: 16) {
                    LogoAndHeadlineView(
                        headline: "Your Results",
                        showLogo: true,
                        allowToPopView: true,
                        height: geometry.size.height * 0.2
                    )
                    
                    Spacer()
                    
                    // Content: Result Values
                    VStack(spacing: 16.0) {
                        
                        // current values
                        HStack(spacing: 16.0) {
                            ResultValues(valueType: "Max Value",
                                         value: Int(round(self.measurement.maxROMFrame.degree)),
                                         showText: true)
                            ResultValues(valueType: "Min Value",
                                         value: Int(round(self.measurement.minROMFrame.degree)),
                                         showText: true)
                        }
                        
                        // last values
                        VStack {
                            Text("Last Measurement (DD/MM/YY)")
                                .font(.system(size: 18))
                                .fontWeight(.light)
                            
                            HStack(spacing: 16.0) {
                                ResultValues(valueType: "Max Degree",
                                             value: self.mockedPreviousMaxValue, showText: false)
                                ResultValues(valueType: "Min. Degree",
                                             value: self.mockedPreviousMinValue, showText: false)
                            }
                        }
                        Button(action: {
                            self.showInfoView.toggle()
                        }) {
                            Text("What do my values mean?")
                        }
                        
                    }
                    
                    Spacer()
                    
                    // Back home button
                    DefaultButton(action: {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.toWelcomeView()
                    }) {
                        Text("Done")
                            .frame(width: geometry.size.width / 3.0)
                    }
                    // Report button
                    DefaultButton(
                        mode: self.canSendMail ? .enabled : .disabled,
                        action: {
                            self.isShowingMailView.toggle()
                    }) {
                        self.canSendMail ?
                            self.possibleMailLabel.frame(width: geometry.size.width / 3.0) :
                            self.notPossibleMailLabel.frame(width: geometry.size.width / 3.0)
                    }
                    .sheet(isPresented: self.$isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }
                .padding(.bottom, 32)
                
                // show InfoView if requested
                if self.showInfoView {
                    VStack {
                        Spacer()
                        InfoView(
                            show: self.$showInfoView,
                            displayDismissButton: true,
                            width: geometry.size.width * 0.9
                        ).frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: self.$isShowingMailView) {
                        MailView(result: self.$result)
                    }
                    
                }
            } // end of ZStack
        }
    }
}

// MARK: - Previews
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        ResultView(
            measurement: DataHandler.mockMeasurements[0]
        )
    }
}
