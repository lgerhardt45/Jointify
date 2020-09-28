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
    /// the chosen joint. Needs to be a Double as the value is used
    ///  for the slider that choses the body side
    @State var chosenJointIndex: Int = 1
    /// the chosen body side. Needs to be a Double as the value is used
    ///  for the slider that choses the body side
    @State var chosenSideIndex: Int = 1
    /// is set by VideoPickerView and sent to Processsing
    @State var videoUrl: NSURL?
    /// source type for the Image Picker: .camera or .photoLibrary
    @State var sourceType: UIImagePickerController.SourceType = .camera
    /// trigger for opening sheet with VideoPicker
    @State var videoPickerSheetIsPresented: Bool = false
    /// trigger for navigation to ProcessingView
    @State var goToProcessingView: Bool = false
    
    // MARK: Recording Not Yet Supported Properties
    @State var showRecordingNotSupportedAlert: Bool = false
    let recordingSupported: Bool = true
    // swiftlint:disable:next line_length
    let recordingNotSupportedText = "Currently, the recording in the app is not supported. Please use the Camera app to record the video and modify it according to the instructions."
    
    // MARK: Body
    var body: some View {
        
        //GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            VStack {
                
                // when video was chosen, send to ProcessingView
                NavigationLink(
                    destination: ProcessingView(
                        videoUrl: self.$videoUrl,
                        // the chosen side returned by the slider is used in the allCases array of Side
                        chosenSide: Side.allCases[Int(self.chosenSideIndex)],
                        chosenJointCase: JointCase.allCases[Int(self.chosenJointIndex)])
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
                        // swiftlint:disable line_length
                        subheadline: "Choose the body side to be analysed and whether you want to use an existing video from your gallery or take a new recording.",
                        // swiftlint:enable line_length
                        width: geometry.size.width * 0.8
                    )
                    
                    Spacer()
                    
                    // Choose joint
                    VStack {
                        Text("Choose joint")
                        JointChooser(
                            chosenJointIndex: self.$chosenJointIndex,
                            width: geometry.size.width * 0.6
                        )
                    }
                    
                    Spacer()
                    
                    // Choose body side
                    VStack {
                        Text("Choose side")
                        BodySideChooser(
                            chosenSideIndex: self.$chosenSideIndex,
                            width: geometry.size.width * 0.6
                        )
                    }
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 16) {
                        
                        // Record
                        DefaultButton(mode: .enabled,
                                      action: {
                            if self.recordingSupported {
                                self.sourceType = UIImagePickerController.SourceType.camera
                                self.videoPickerSheetIsPresented.toggle()
                            } else {
                                self.showRecordingNotSupportedAlert.toggle()
                            }
                        }) {
                            Text("Record").frame(width: geometry.size.width / 3.0)
                        }
                        
                        // Gallery
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
                        
                    .alert(isPresented: self.$showRecordingNotSupportedAlert) {
                        Alert(
                            title: Text("Recording not supported yet"),
                            message: Text(self.recordingNotSupportedText),
                            dismissButton: .cancel(Text("Dismiss")))
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
