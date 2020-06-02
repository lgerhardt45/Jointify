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
    @State var showImagePicker: Bool = false
    @State var image: Image?
    @State var showActionSheet: Bool = false
    @State var sourceType: Int = 0 // If source is camerea 0, if source gallery 1
    let defaultImage: Image = Image("placeholder") // Default image to show to user, before he selected an image
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Spacer()
                Text("Welcome!")
                    .fontWeight(.bold)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Spacer()
                Spacer()
                CameraButton(showActionSheet: $showActionSheet)
                Spacer()
                Text("Your image selection:")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                Spacer()
            }
            .actionSheet(isPresented: $showActionSheet,
                         content: { () -> ActionSheet in ActionSheet(
                            title: Text("Select Image"),
                            message: Text("Please select an image from the image gallery or use the camera"),
                            buttons: [
                                ActionSheet.Button.default(Text("Camera"), action: {
                                    self.sourceType = 0
                                    self.showImagePicker.toggle()
                                }),
                                ActionSheet.Button.default(Text("Photo Gallery"), action: {
                                    self.sourceType = 1
                                    self.showImagePicker.toggle()
                                }),
                                ActionSheet.Button.cancel()
                            ])
            })
            if showImagePicker {
                ImagePicker(isVisible: $showImagePicker, image: $image, sourceType: sourceType)
            }
        }
        .onAppear { self.image = self.defaultImage}
    }
}

// MARK: Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
