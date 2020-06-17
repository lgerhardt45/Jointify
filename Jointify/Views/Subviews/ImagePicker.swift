//
//  MediaPicker.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 02.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import UIKit
import CoreServices

// MARK: - MediaPicker
struct MediaPicker: UIViewControllerRepresentable {
    
    // MARK: Binding Instance Properties
    @Binding var videoPickerSheetIsPresented: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var videoURL: NSURL?
    
    // MARK: Internal Instance Methods
    /// UIViewControllerRepresentable protocol method
    internal func makeUIViewController(context: Context) -> UIImagePickerController {
        
        // create media picker
        let imagePicker = UIImagePickerController()
        
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    /// UIViewControllerRepresentable protocol method
    internal func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    internal func makeCoordinator() -> NavigationControllerCoordinator {
        NavigationControllerCoordinator(videoPickerSheetIsPresented: $videoPickerSheetIsPresented,
                    videoURL: $videoURL,
                    sourceType: $sourceType)
    }
}

// MARK: - NavigationControllerCoordinator
class NavigationControllerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Binding Instance Properties
    @Binding var videoPickerSheetIsPresented: Bool
    @Binding var videoURL: NSURL?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    // MARK: Initializers
    init(videoPickerSheetIsPresented: Binding<Bool>,
         videoURL: Binding<NSURL?>,
         sourceType: Binding<UIImagePickerController.SourceType>) {
        _videoPickerSheetIsPresented = videoPickerSheetIsPresented
        _videoURL = videoURL
        _sourceType = sourceType
    }
    
    // MARK: Private Instance Methods
    /// supplies the selected media in `info`
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else {
            return
        }
        
        print("Selected video: \(videoURL)")
        self.videoURL = videoURL
        
        self.videoPickerSheetIsPresented.toggle()
        
    }
    
    /// reports Cancel event in UIImagePickerController
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.videoPickerSheetIsPresented.toggle()
    }
}
