//
//  ChooseInputView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 03.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ChooseInputView
struct ChooseInputView: View {
    @Binding var isNavigationBarHidden: Bool
    
    var body: some View {
        VStack {
            Button("Use camera") {
                
            }.frame(width: 200)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
            
            Spacer()
                .frame(height: 18)
            
            Button("Open gallery") {
                
            }.frame(width: 200)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                .navigationBarTitle("Choose input", displayMode: .inline)
                .onAppear {
                    self.isNavigationBarHidden = false
            }
        }
        
    }
}

// MARK: - Previews
struct ChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView(isNavigationBarHidden: .constant(false))
    }
}
