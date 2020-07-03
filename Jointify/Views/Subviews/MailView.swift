//
//  MailView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 18.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import UIKit
import MessageUI

// MARK: - Coordinator
/// from https://stackoverflow.com/a/58693164
class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    
    // MARK: Binding Instance Properties
    @Binding var presentation: PresentationMode
    @Binding var pdfData: Data
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    // MARK: Initializers
    init(presentation: Binding<PresentationMode>,
         pdfData: Binding<Data>,
         result: Binding<Result<MFMailComposeResult, Error>?>) {
        _presentation = presentation
        _pdfData = pdfData
        _result = result
    }
    
    // MARK: Instance Methods
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        defer {
            $presentation.wrappedValue.dismiss()
        }
        guard error == nil else {
            self.result = .failure(error!)
            return
        }
        self.result = .success(result)
    }
}

// MARK: - MailView
/// from https://stackoverflow.com/a/58693164
struct MailView: UIViewControllerRepresentable {
    
    // MARK: Environment Properties
    @Environment(\.presentationMode) var presentation
    
    // MARK: Binding Instance Properties
    @Binding var pdfData: Data
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    // MARK: Overridden/ Lifecycle Methods
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = context.coordinator
        
        // setup compose view
        var messageBody = "Dear Doc Pförringer,"
        messageBody += "\n\nplease find attached the copy of my recent ROM measurement."
        composeVC.setMessageBody(messageBody, isHTML: false)
        composeVC.setSubject("ROM measurement from today")
        
        // attach PDF
        composeVC.addAttachmentData(self.pdfData, mimeType: "application/pdf", fileName: "ROM-measurement.pdf")

        return composeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           pdfData: $pdfData,
                           result: $result)
    }
}
