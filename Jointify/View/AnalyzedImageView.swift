//
//  AnalyzedImageView.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 02.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - AnalyzedImageView
struct AnalyzedImageView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("Your analyzed image:")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .padding()
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
            Text("Thanks a lot!\nDoc Pförringer will get back to you with further feedback.")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .padding()
            Spacer()
        }.navigationBarTitle("Analyzed Image")
    }
    
}

// MARK: - Previews
struct AnalyzedImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzedImageView()
    }
}
