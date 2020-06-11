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
    
    // MARK: Binding Instance Properties
    @Binding var isNavigationBarHidden: Bool
    
    // MARK: State Instance Properties
    // ImagePickerVariables
    @State var image: Image?
    @State var isImagePickerShowing: Bool = false
    @State var sourceType: Int // 0 camera, 1 gallery
    @State var isShowingSelectionButton: Bool = true
    // if this is changed, the "your selected image" screen will be loaded in the same view
    @State var imagePickerCanceled: Bool = false
    // this helps preventing loading the "your selected image" screen, if the image picker is canceled
    @State var isShowingAnalyzedImageView: Bool = false
    
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
                }
//                else if !imagePickerCanceled {
//                    Text("Your image selection:")
//                        .font(.system(size: 40))
//                        .foregroundColor(.blue)
//                    image?
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 250, height: 250)
//                    NavigationLink(
//                        destination: AnalyzedImageView(),
//                        // TODO: better solution
//                    isActive: $isShowingAnalyzedImageView) {
//                        Button("Analyze image") {
//                            self.isShowingAnalyzedImageView = true
//                        }.padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                    }
//                }
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
