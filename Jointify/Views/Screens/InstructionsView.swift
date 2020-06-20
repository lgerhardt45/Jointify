//
//  InstructionsView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionsView
struct InstructionsView: View {
    
    // MARK: Binding Instance Properties
    // navigation bar properties (hidden or not) lie onn avigation view
    //   (root view) and have to be modified there
    @Binding var isNavigationBarHidden: Bool
    
    // MARK: State Instance Properties
    @State var understoodButtonPressed: Bool = false
    
    // MARK: Body
    var body: some View {
        
        //GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            //Outer VStack
            VStack(spacing: 16.0) {
                
                // 20% for the Header
                LogoAndHeadlineView(headline: "Instructions", showLogo: true, height: geometry.size.height * 0.20)
                
                // SubHeadline
                SubHeadline(subheadline: "Would you like to start a new recording or use an existing one?", width: geometry.size.width / 2.0)
                
                //Content
                InstructionContent().padding()
                
                Spacer()
                
                // Move video data to ProcessingView
                VStack(spacing: 16.0) {
                    NavigationLink(
                        destination: ChooseInputView(
                        ),
                        isActive: self.$understoodButtonPressed
                    ) {
                        DefaultButton(action: {
                            // activate NavigationLink to ChooseInputView
                            self.understoodButtonPressed.toggle()
                        }) {
                            Text("I understand")
                                .frame(width: geometry.size.width / 3.0)
                        } }
                }
            }.navigationBarTitle(Text("Instructions"), displayMode: .inline)
                .navigationBarHidden(self.isNavigationBarHidden) // is turned to 'false' in WelcomeView
                .padding(.all)
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView(isNavigationBarHidden: .constant(false))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InstructionsView(isNavigationBarHidden: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            InstructionsView(isNavigationBarHidden: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}
#endif
