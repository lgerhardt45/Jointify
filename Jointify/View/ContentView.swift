//
//  ContentView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 27.05.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import AVKit

// MARK: - ContentView
struct ContentView: View {

    @State private var isShowingSecondView = false
    @State var isNavigationBarHidden: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Welcome!")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .navigationBarTitle("") //Is this correct here?
                    .navigationBarHidden(self.isNavigationBarHidden)
                
                Spacer()
                
                NavigationLink(
                    destination: ChooseInputView(
                        isNavigationBarHidden: $isNavigationBarHidden,
                        sourceType: 0),
                    // TODO: don't use hardoced value here
                isActive: $isShowingSecondView) {
                    Button("Start measurement") {
                        self.isShowingSecondView = true
                    }.padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
