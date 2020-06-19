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
    
    // MARK: Body
    var body: some View {
        
        // starts the navigation stack (screens are loaded "on top" of each other
        NavigationView {
            VStack {
                Spacer().frame(height: 150
                )
                
                VStack(spacing: 16.0) {
                    Text("Hello!")
                        .font(.largeTitle)
                        .font(.system(size:48))
                    Text("Start your remote joint measurement journey.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .font(.system(size:20))
                        .frame(width: 220.0)
                    
                    Spacer()
                        .frame(height: 70)
                    
                    NavigationLink(
                        destination: InstructionsView(
                            isNavigationBarHidden: $isNavigationBarHidden),
                        isActive: $newRecordButtonPressed) {
                            DefaultButton(action: {
                                self.newRecordButtonPressed.toggle()
                                self.isNavigationBarHidden = false
                            }) {
                                Text("Start")
                                .frame(width: 150)

                            }
                    }
                }
                
                Spacer()
                PastRecords()
                    .frame(height: 250) // size from bottom
            }.onAppear(perform: {
                // always hidden on this screen
                self.isNavigationBarHidden = true
            })
                // hide the navigation bar
                .navigationBarTitle("")
                .navigationBarHidden(self.isNavigationBarHidden)
                .padding(.all)
        }
    }
}

// MARK: - Previews
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
