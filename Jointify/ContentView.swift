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

// MARK: ContentView
struct ContentView: View {
    
    @State var image: Image?
    
    var body: some View {
        ZStack {
            VStack {
                CameraButton()
                image?.resizable()
                  .frame(width: 250, height: 250)
                  .clipShape(Circle())
                  .overlay(Circle().stroke(Color.white, lineWidth: 4))
                  .shadow(radius: 10)
            }
        }

    }
}

// MARK: Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
