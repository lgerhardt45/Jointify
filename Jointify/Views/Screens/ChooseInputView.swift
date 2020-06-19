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
        
        VStack {
            // when video was chosen, send to ProcessingView
            NavigationLink(
                destination: ProcessingView(videoUrl: self.$videoUrl),
                isActive: self.$goToProcessingView) {
                    EmptyView()
            }
            
            VStack(spacing: 16) {
                Logo()
                Spacer().frame(height: 81
                )
                VStack(spacing: 16) {
                    Text("Measurement")
                    .font(.largeTitle)
                    .font(.system(size:48))
                    Text("Would you like to start a new recording or use an existing one?")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .font(.system(size:20))
                        .frame(width: 220.0)
                }
                Spacer()
                /*Image(systemName: "camera")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()*/
                
                VStack(spacing: 8) { // Buttons
                    
                    // don't show Record button in simulator to avoid accidental crashes
                    #if !targetEnvironment(simulator)
                    DefaultButton(action: {
                        self.sourceType = UIImagePickerController.SourceType.camera
                        self.videoPickerSheetIsPresented.toggle()
                    }) {
                        Text("Record").frame(width: 150)
                    }.padding(.all, 10)
                    #endif
                    
                    DefaultButton(action: {
                        self.sourceType = UIImagePickerController.SourceType.photoLibrary
                        self.videoPickerSheetIsPresented.toggle()
                    }) {
                        Text("Gallery").frame(width: 150)
                    }
                    .frame(width: nil)
                    .padding(.all, 10)
                    
                }
                    
                .sheet(isPresented: $videoPickerSheetIsPresented, onDismiss: {
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

struct LukasChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView()
    }
}
