//
//  CameraButton.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 28.05.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct CameraButton: View {
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Button(action: {
            // what the button does
            self.showActionSheet.toggle()
            print("Button pressed")
        }, label: {
            // what the button looks like
            HStack {
                Circle()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.white)
                    .overlay(Image(systemName: "square.and.arrow.up").foregroundColor(Color.blue)) // maybe camera.fill
                Text("Select an image")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
            }
        })

        .padding()
        .background(Color.blue)
        .cornerRadius(40)

    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { _ in
            CameraButton(showActionSheet: .constant(false))
        }.background(Color("Background")).previewLayout(.sizeThatFits)
    }
}
