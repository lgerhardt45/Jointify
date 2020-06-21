//
//  BackButton.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 21.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - BackButton
struct BackButton: View {
    
    // MARK: Environment Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: Stored Instance Methods
    func popView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: Body
    var body: some View {
        
        HStack {
            Button(action: {
                self.popView()
            }) {
                Image(systemName: "chevron.left").resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .frame(height: Logo.height * CGFloat(0.4))
            }.padding(.leading)
            
            // push button to the left
            Spacer()
        }
    }
}

// MARK: Previews
struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
