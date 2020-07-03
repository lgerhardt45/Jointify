//
//  InstructionContent.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionContent
struct InstructionContent: View {
    
    // MARK: Stored Instance Properties
    let instructionPointWidth: CGFloat
    
    // swiftlint:disable line_length
    private let instructionsMessage1 =
    "1) Lift your leg in the air."
    
    private let instructionsMessage2 =
    "2) Bend your knee as far as possible."
    
    private let instructionsMessage3 =
    "3) Straighten your knee as far as possible."
    
    private let instructionsMessage4 =
    "4) Bring your leg back into the initial position."
    
    let videoEditingInstructions1 =
    "1) Go to your Gallery and start editing the video."
    
    let videoEditingInstructions2 =
    "2) Trim video so that the first frame is the initial position as indicated above."
    
    let videoEditingInstructions3 =
    "3) Trim video so that the last frame is the initial position as indicated above."
    
    let videoEditingInstructions4 =
    "4) Select the crop symbol."
    
    let videoEditingInstructions5 =
    "5) Select the resize symbol."
    
    let videoEditingInstructions6 =
    "6) Select square format and press done."
    
    let privacyDisclaimer =
    "No submitted videos will be saved or leave your phone in any way. All these restrictions are simply needed to ensure correct measurement results."
    
    let howToImprove = [
        "Find a suitable spot with as little visual distraction as possible. The analysis works best in front of a plain white wall.",
        "Place your mobile phone roughly 3 meters away from you on a object which is at least 60 centimetres high (e.g. a chair) or on the floor. It is important that your whole body is in the centre of the picture, since you have to submit a video in square format.",
        "Make sure that your face is visible (no caps or similar), as it helps the analysis to identify your complete body pose.",
        "Please wear short pants or underwear, since trousers can distort the measurement results.",
        "Please be barefoot.",
        "Please ensure that there is no lighting source in the background facing the camera (e.g. windows)."
    ]
    // swiftlint:enable line_length
    
    // MARK: Body
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 24) {
                
                // Recording Instructions
                VStack {
                    
                    InstructionHeadline(headline: "Recording Instructions")
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 16) {
                            
                            InstructionPoint(
                                text: instructionsMessage1,
                                image: Image("initial_position"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: instructionsMessage2,
                                image: Image("flexion"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: instructionsMessage3,
                                image: Image("extension"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: instructionsMessage4,
                                image: Image("initial_position"),
                                width: instructionPointWidth)
                            
                        }.padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                        )
                    }
                }
                
                // Editing Instructions
                VStack {
                    
                    InstructionHeadline(headline: "Editing Instructions")
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 16) {
                            
                            InstructionPoint(
                                text: videoEditingInstructions1,
                                image: Image("Edit"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: videoEditingInstructions2,
                                image: Image("TrimStart"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: videoEditingInstructions3,
                                image: Image("TrimEnd"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: videoEditingInstructions4,
                                image: Image("CropStarts"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: videoEditingInstructions5,
                                image: Image("CropMid"),
                                width: instructionPointWidth)
                            
                            InstructionPoint(
                                text: videoEditingInstructions6,
                                image: Image("CropEnd"),
                                width: instructionPointWidth)
                            
                        }.padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                        )
                    }
                }
                
                // How to improve your video
                VStack(spacing: 8) {
                    BulletedList(headline: "How to improve your video", text: howToImprove)
                }
                
                // Privacy Disclaimer
                VStack(spacing: 8) {
                    Text("Privacy Disclaimer")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(privacyDisclaimer)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.all)	
    }
}

// MARK: - Previews
struct InstructionContent_Previews: PreviewProvider {
    static var previews: some View {
        InstructionContent(instructionPointWidth: 300)
    }
}
