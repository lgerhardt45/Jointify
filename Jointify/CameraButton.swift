//
//  CameraButton.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 28.05.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct CameraButton: View {
    var body: some View {
        Button(action: {
            // what the button does
            print("Button pressed")
            
        }) {
            // what the button looks like
            Text("Open camera")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
            
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(40)

    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            CameraButton()
        }.background(Color("Background")).previewLayout(.sizeThatFits)
    }
}
