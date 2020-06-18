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
class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    
    // MARK: Binding Instance Properties
    @Binding var presentation: PresentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    // MARK: Initializers
    init(presentation: Binding<PresentationMode>,
         result: Binding<Result<MFMailComposeResult, Error>?>) {
        _presentation = presentation
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
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    // MARK: Overridden/ Lifecycle Methods
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
    
    // MARK: Instance Methods
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
}
