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
                    .navigationBarTitle("")
                    .navigationBarHidden(self.isNavigationBarHidden)
                Spacer()
                
                NavigationLink(
                destination: ChooseInputView(isNavigationBarHidden: $isNavigationBarHidden),
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

// Previous stuff:
//       .actionSheet(isPresented: $showActionSheet,
//                     content: { () -> ActionSheet in ActionSheet(
//                        title: Text("Select Image"),
//                        message: Text("Please select an image from the image gallery or use the camera"),
//                        buttons: [
//                            ActionSheet.Button.default(Text("Camera"), action: {
//                                self.sourceType = 0
//                                self.showImagePicker.toggle()
//                                self.showWelcomeScreen.toggle()
//                                }),
//                            ActionSheet.Button.default(Text("Photo Gallery"), action: {
//                                self.sourceType = 1
//                                self.showImagePicker.toggle()
//                                self.showWelcomeScreen.toggle()
//                            }),
//                            ActionSheet.Button.cancel()
//                        ])
//        })
//        if showImagePicker {
//            ImagePicker(isVisible: $showImagePicker, image: $image, sourceType: sourceType)
//        }
//    }
//    //.onAppear { self.image = self.defaultImage} only needed if we want to display a default picture
//}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
