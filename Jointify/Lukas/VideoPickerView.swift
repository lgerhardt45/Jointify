//
//  ImagePickerView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import UIKit

// MARK: - ImagePickerView
struct VideoPickerView: View {
    
    // MARK: Environment Properties
    @Environment(\.presentationMode) private var presentationMode

    // MARK: Binding Instance Properties
    @Binding var videoAsImageArray: [UIImage]
    @Binding var videoChosen: Bool
    
    // 
    // MARK: Body
    var body: some View {
        VStack {
            
            if !videoChosen {
                Text("Give me a video")
                
                Spacer()
                    .frame(height: 32)
                
                // send data (image, bool) to InstructionsView and dismiss on click
                DefaultButton(action: {
                    
                    guard let image = UIImage(systemName: "heart.fill") else { return }
                    
                    self.videoAsImageArray.append(image)
                    self.videoChosen = true
                    
                    // dismiss this sheet
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Get that video!")
                }
            }
            
            
        }
    }
    
    // MARK: Private Instance Methods
    /// splits a video into its frames, returning an Array of UIImages
    private func videoToImageArray() -> [UIImage] {
        return []
    }
    
}
