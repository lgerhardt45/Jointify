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

    // MARK: State Instance Properties
    @State var understoodButtonPressed: Bool = false
    
    // MARK: Body
    var body: some View {
        
        //GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            //Outer VStack
            VStack(spacing: 16.0) {
                
                // 20% for the Header
                LogoAndHeadlineView(
                    headline: "Beta Instructions",
                    showLogo: true,
                    allowToPopView: true,
                    height: geometry.size.height * 0.20
                )
                
                // Content
                InstructionContent()
                    .padding(.horizontal, 24)
                
                // "I understand" button to ChooseInputView
                NavigationLink(
                    destination: ChooseInputView()
                        // hide the navigation bar on the ChooseInputView, too
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$understoodButtonPressed
                ) {
                    DefaultButton(action: {
                        // activate NavigationLink to ChooseInputView
                        self.understoodButtonPressed.toggle()
                    }) {
                        Text("I understand")
                            .frame(width: geometry.size.width / 3.0)
                    }
                }
            }.padding(.bottom, 32)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InstructionsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            InstructionsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}
#endif
