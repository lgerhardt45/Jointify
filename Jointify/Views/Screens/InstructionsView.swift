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
        VStack(spacing: 16.0) {
            Logo()
            Spacer().frame(height: 86)
            // pass the State variable to the other View which modifies it
            Text("Instructions")
                .font(.largeTitle)
                .font(.system(size:48))
            Text("Would you like to start a new recording or use an existing one?")
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .font(.system(size:20))
            .frame(width: 220.0)
                       
            Spacer().frame(height: 20)
            InstructionContent()
            Spacer()
            
            // Move video data to ProcessingView
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
                } }
        }.navigationBarTitle(Text("Instructions"), displayMode: .inline)
            .navigationBarHidden(isNavigationBarHidden) // is turned to 'false' in WelcomeView
            .padding(.all)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView(isNavigationBarHidden: .constant(false))
    }
}
