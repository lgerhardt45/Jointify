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
    "2) Cut video such that the first frame is the initial position as indicated above."
    
    let videoEditingInstructions3 =
    "3) Cut video such that the last frame is the initial position as indicated above."
    
    let howToImprove = [
        "Find a suitable spot with as little visual distraction as possible. The analysis works best in front of a plain white wall.",
        "Place your mobile phone on a object (e.g. a chair) or on the floor.",
        "Make sure that your face is visible (no caps or similar) and show the palms of your hands.",
        "Please wear short pants or underwear, since trousers can distort the measurement results.",
        "Please be barefoot.",
        "Please ensure that there is no lighting source in the background facing the camera (e.g. windows).",
        "Make sure to excecute the movement slow and steady."
    ]
    
    let privacyDisclaimer =
    "No submitted videos will be saved or leave your phone in any way. All these restrictions are simply needed to ensure correct measurement results."
    // swiftlint:enable line_length
    
    // MARK: Body
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 24) {
                
                // Recording Instructions
                VStack {
                    
                    InstructionHeadline(headline: "Recording Instructions")
                    
                    Text("Make sure that your whole body is visible in the video.")
                        .multilineTextAlignment(.center)
                    
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
