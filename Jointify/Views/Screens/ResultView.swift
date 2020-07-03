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
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var pdfData: Data = Data()

    
    // MARK: Stored Instance Properties
    let measurement: Measurement
    let mockedPreviousMinValue: Int = -45
    let mockedPreviousMaxValue: Int = 80
    let cannotSendMailErrorMessage =
    "We cannot send the report. Please make sure that your mail account is setup on your phone."
    
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

                        // Button for InfoView
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
                            
                            // possible to send mail
                            if self.canSendMail {
                                
                                let writer = MeasurementSheetPDFWriter(measurement: self.measurement)
                                
                                writer.createPDF { result in
                                    switch result {
                                    
                                    // sucessfully written measurements on PDF
                                    case .success(let pdfData):
                                        self.pdfData = pdfData
                                        self.isShowingMailView.toggle()
                                    
                                    // error writing pdf: show alert
                                    case .failure(let error):
                                        self.alertMessage = error.localizedDescription
                                        self.isShowingAlert.toggle()
                                    }
                                }
                                
                            } else {
                                // mail not configured
                                self.alertMessage = self.cannotSendMailErrorMessage
                                self.isShowingAlert.toggle()
                            }
                    }) {
                        // Button style
                        self.canSendMail ?
                            self.possibleMailLabel.frame(width: geometry.size.width / 3.0) :
                            self.notPossibleMailLabel.frame(width: geometry.size.width / 2.0)
                    }
                        
                    .sheet(isPresented: self.$isShowingMailView) {
                        MailView(pdfData: self.$pdfData, result: self.$result)
                    }
    
                    .alert(isPresented: self.$isShowingAlert) {
                        Alert(
                            title: Text(self.alertTitle),
                            message: Text(self.alertMessage),
                            dismissButton: .cancel(Text("Dismiss")))
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
