//
//  WelcomeView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ImportView
struct WelcomeView: View {
    
    // MARK: Constants
    enum Constants {
        static let headerHeightPercentage: CGFloat = 0.2
        static let subHeadlineWidthPercentage: CGFloat = 0.5
    }
    
    // MARK: State Instance Properties
    // used to hide the navigation bar
    @State private var isNavigationBarHidden: Bool = true
    // used to activate the NavigationLink (next screen)
    @State private var newRecordButtonPressed: Bool = false
    
    // MARK: Body
    var body: some View {
        
        // starts the navigation stack (screens are loaded "on top" of each other
        NavigationView {
            
            // GeometryReader to allow for percentage alignments
            GeometryReader { geometry in
                
                // Outer VStack
                VStack(spacing: 16.0) {
                    
                    // 20% for the Header
                    LogoAndHeadlineView(
                        headline: "Hello!",
                        showLogo: false,
                        height: geometry.size.height * Constants.headerHeightPercentage)
                    
                    // SubHeadline
                    SubHeadline(
                        subheadline: "Start your remote joint measurement journey.",
                        width: geometry.size.width * Constants.subHeadlineWidthPercentage
                    )
                    
                    Spacer()
                    
                    // "Start" button to InstructionsView
                    NavigationLink(
                        destination: InstructionsView()
                            // hide the navigation bar there, too
                            .navigationBarTitle("")
                            .navigationBarHidden(true),
                        isActive: self.$newRecordButtonPressed) {
                            DefaultButton(action: {
                                self.newRecordButtonPressed.toggle()
                            }) {
                                Text("Start")
                                    .frame(width: geometry.size.width / 3.0)
                            }
                    }
                    
                    Spacer()
                    
                    // Show past records
                    PastRecords()
                    
                }.padding(.bottom)
                    
                    // hide the navigation bar
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
        }
    }
}

// MARK: - Previews
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
