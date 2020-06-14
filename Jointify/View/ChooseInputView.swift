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
    @State var image: Image?
    @State var isImagePickerShowing: Bool = false
    @State var sourceType: Int // if 0 camera is selected, if 1 gallery
    @State var isShowingSelectionButton: Bool = true
    // if this is changed, the "your selected image" screen will be loaded in the same view
    @State var imagePickerCanceled: Bool = false
    // this helps preventing loading the "your selected image" screen, if the image picker is canceled
    @State var isShowingAnalyzedImageView: Bool = false
    
    let poseNet = PoseNet()
    
    @State var finalImage = UIImage(named: "surgery") //UIImage?
   
    var body: some View {
        NavigationView {
        VStack {
                if isShowingSelectionButton {
                    Button("Use camera") {
                        self.sourceType = 0
                        self.isImagePickerShowing.toggle()
                        self.isShowingSelectionButton.toggle()
                    }.sheet(isPresented: $isImagePickerShowing, onDismiss: {
                        self.isImagePickerShowing = false
                    }) {
                        ImagePicker(
                            isVisible: self.$isImagePickerShowing,
                            image: self.$image,
                            isShowingSelectedImage: self.$isShowingSelectionButton,
                            imagePickerCanceled: self.$imagePickerCanceled,
                            sourceType: self.sourceType)
                    }
                    .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    
                    Spacer()
                        .frame(height: 18)
                    
                    Button(action: {
                        self.sourceType = 1
                        self.isImagePickerShowing.toggle()
                        //self.isShowingSelectionButton.toggle()
                    }, label: {
                        Text("Open gallery")
                    }).sheet(isPresented: $isImagePickerShowing,
                             onDismiss: {
                                self.isImagePickerShowing = false
                            }) {
                        ImagePicker(
                            isVisible: self.$isImagePickerShowing,
                            image: self.$image,
                            isShowingSelectedImage: self.$isShowingSelectionButton,
                            imagePickerCanceled: self.$imagePickerCanceled,
                            sourceType: self.sourceType)
                    }
                    .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        
                        .navigationBarTitle("Choose input", displayMode: .inline)
                        .onAppear {
                            self.isNavigationBarHidden = false
                    }
                } else if !imagePickerCanceled {
                    Text("Your image selection:")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    image? // TODO: avoid force unwrap
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                    NavigationLink(
                        destination: AnalyzedImageView(finalImage: self.finalImage!),
                        // TODO: better solution
                    isActive: $isShowingAnalyzedImageView) {
                        Button("Analyze image") {
                            //
                            self.finalImage = self.poseNet.predict(UIImage(named: "niklas-3")!)
                            //
                            self.isShowingAnalyzedImageView = true
                        }.padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }.navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

// MARK: - Previews
struct ChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView(isNavigationBarHidden: .constant(false), sourceType: 0)
    }
}
