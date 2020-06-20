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
    
    // MARK: State Instance Properties
    // used to hide the navigation bar
    @State private var isNavigationBarHidden: Bool = true
    // used to activate the NavigationLink (next screen)
    @State private var newRecordButtonPressed: Bool = false
    
    //
    static let textFramePercentage = 0.1
    // MARK: Body
    var body: some View {
        
        // starts the navigation stack (screens are loaded "on top" of each other
        NavigationView {
            
            //GeometryReader to allow for percentage alignments
            GeometryReader { geometry in
                
                // Outer VStack
                VStack(spacing: 16.0) {
                    
                    // 20% for the Header
                    LogoAndHeadlineView(headline: "Hello!", showLogo: false, height: geometry.size.height * 0.20)
                    
                    // SubHeadline
                    SubHeadline(
                        subheadline: "Start your remote joint measurement journey.",
                        width: geometry.size.width / 2.0
                    )
                    
                    Spacer()
                    
                    //Navigation
                    VStack(spacing: 16.0) {
                        NavigationLink(
                            destination: InstructionsView(
                                isNavigationBarHidden: self.$isNavigationBarHidden),
                            isActive: self.$newRecordButtonPressed) {
                                DefaultButton(action: {
                                    self.newRecordButtonPressed.toggle()
                                    self.isNavigationBarHidden = false
                                }) {
                                    Text("Start")
                                        .frame(width: geometry.size.width / 3.0)
                                    
                                }
                        }
                    }
                    
                    Spacer()
                    
                    // Show past records
                    PastRecords()
                    
                }.onAppear(perform: {
                    // always hidden on this screen
                    self.isNavigationBarHidden = true
                })
                    .padding(.bottom)
                    // hide the navigation bar
                    .navigationBarTitle("")
                    .navigationBarHidden(self.isNavigationBarHidden)
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
//
//extension View {
//    let upperFramePercentage = 0.4
//    let middleFramePercentage = 0.4
//    let lowerFramePercentage = 0.2
//}
