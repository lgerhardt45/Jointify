//
//  AnalyzeButton.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 02.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct AnalyzeButton: View {
    
    @State var showingAnalyzedImageView: Bool = false
    
    var body: some View {
        Button(action: {
            // what the button does
            self.showingAnalyzedImageView.toggle()
            print("Button pressed")
        }, label: {
            // what the button looks like
            HStack {
                Circle()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.white)
                    .overlay(Image(systemName: "square.and.arrow.down")
                    .foregroundColor(Color.blue)) // maybe camera.fill
                Text("Analyze image")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
            }
        }).sheet(isPresented: $showingAnalyzedImageView) {
            AnalyzedImageView()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(40)
    }
}
