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
    /// the chosen body side. Needs to be a Double as the value is used
    ///  for the slider that choses the body side
    @State var chosenSideIndex: Double = 0
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
        
        //GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            VStack {
                
                // when video was chosen, send to ProcessingView
                NavigationLink(
                    destination: ProcessingView(videoUrl: self.$videoUrl)
                        // hide the navigation bar on the ProcessingView, too
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$goToProcessingView) {
                        EmptyView()
                }
                
                // Outer VStack
                VStack(spacing: 16) {
                    
                    // 20% for the Header
                    LogoAndHeadlineView(
                        headline: "Measurement",
                        showLogo: true,
                        allowToPopView: true,
                        height: geometry.size.height * 0.20
                    )
                    
                    // SubHeadline
                    SubHeadline(
                        subheadline: "Choose the body side to be analysed and whether you want to use an existing or a new recording.",
                        width: geometry.size.width * 0.8
                    )
                    
                    Spacer()
                    
                    VStack(spacing: 16) { // Buttons
                        
                        // don't show Record button in simulator to avoid accidental crashes
                        #if !targetEnvironment(simulator)
                        DefaultButton(action: {
                            self.sourceType = UIImagePickerController.SourceType.camera
                            self.videoPickerSheetIsPresented.toggle()
                        }) {
                            Text("Record").frame(width: geometry.size.width / 3.0)
                        }
                        #endif
                        
                        DefaultButton(action: {
                            self.sourceType = UIImagePickerController.SourceType.photoLibrary
                            self.videoPickerSheetIsPresented.toggle()
                        }) {
                            Text("Gallery").frame(width: geometry.size.width / 3.0)
                        }
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
                }.padding(.bottom, 32)
            }
        }
        
    }
}

// MARK: - Previews
struct ChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView()
    }
}
