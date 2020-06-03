//
//  ImagePicker.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 02.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isVisible: Bool
    @Binding var image: Image?
    @Binding var isShowingSelectedImage: Bool
    @Binding var imagePickerCanceled: Bool
    var sourceType: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isVisible: $isVisible,
                    image: $image,
                    isShowingSelectedImage: $isShowingSelectedImage,
                    imagePickerCanceled: $imagePickerCanceled)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        if sourceType == 1 {
            imagePicker.sourceType = .photoLibrary
        } else {
            imagePicker.sourceType = .camera
        }
        
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    // apparently this is needed for the moment
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isVisible: Bool
        @Binding var image: Image?
        @Binding var isShowingSelectedImage: Bool
        @Binding var imagePickerCanceled: Bool
        
        init(isVisible: Binding<Bool>,
             image: Binding<Image?>,
             isShowingSelectedImage: Binding<Bool>,
             imagePickerCanceled: Binding<Bool>) {
            _isVisible = isVisible
            _image = image
            _isShowingSelectedImage = isShowingSelectedImage
            _imagePickerCanceled = imagePickerCanceled
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = Image(uiImage: uiImage)
            }
            isVisible = false
            isShowingSelectedImage = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isVisible = false
            imagePickerCanceled.toggle()
        }
    }
}
