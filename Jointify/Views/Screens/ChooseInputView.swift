//
//  LukasChooseInputView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 12.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: ChooseInputView
struct ChooseInputView: View {
    
    // MARK: State Instance Properties
    /// is set by VideoPickerView and sent to Processsing
    @State var videoUrl: NSURL?
    /// source type for the Image Picker: .camera or .photoLibrary
    @State var sourceType: UIImagePickerController.SourceType = .camera
    /// trigger for opening sheet with VideoPicker
    @State var videoPickerSheetIsPresented: Bool = false
    /// trigger for navigation to ProcessingView
    @State var goToProcessingView: Bool = false
    
    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // when video was chosen, send to ProcessingView
                NavigationLink(
                    destination: ProcessingView(videoUrl: self.$videoUrl),
                    isActive: self.$goToProcessingView) {
                        EmptyView()
                }
                
                VStack(spacing: 16) {
                    LogoAndHeadlineView(headline: "Measurement", showLogo: true, height: geometry.size.height * 0.20)
                    
                    //SubHeadline
                    SubHeadline(subheadline: "Would you like to start a new recording or use an existing one?", width: geometry.size.width / 2.0)
                    
                    Spacer()
                    
                    VStack(spacing: 16) { // Buttons
                        
                        // don't show Record button in simulator to avoid accidental crashes
                        #if !targetEnvironment(simulator)
                        DefaultButton(action: {
                            self.sourceType = UIImagePickerController.SourceType.camera
                            self.videoPickerSheetIsPresented.toggle()
                        }) {
                            Text("Record").frame(width: geometry.size.width / 3.0)
                        }.padding(.all, 10)
                        #endif
                        
                        DefaultButton(action: {
                            self.sourceType = UIImagePickerController.SourceType.photoLibrary
                            self.videoPickerSheetIsPresented.toggle()
                        }) {
                            Text("Gallery").frame(width: geometry.size.width / 3.0)
                        }
                        .frame(width: nil)
                        .padding(.all, 10)
                        
                    }
                        
                    .sheet(isPresented: self.$videoPickerSheetIsPresented, onDismiss: {
                        if self.videoUrl != nil {
                            self.goToProcessingView.toggle()
                        }
                    }) {
                        MediaPicker(
                            videoPickerSheetIsPresented: self.$videoPickerSheetIsPresented,
                            sourceType: self.$sourceType,
                            videoURL: self.$videoUrl)
                    }
                }
                .padding(.all)
            }
        }
        
    }
}

struct LukasChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView()
    }
}
