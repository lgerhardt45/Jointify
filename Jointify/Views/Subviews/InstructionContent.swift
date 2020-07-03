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
                VStack(spacing: 16) {
                    InstructionHeadline(headline: "Recording Instructions")
                    InstructionPoint(text: instructionsMessage1, image: Image("initial_position"))
                    InstructionPoint(text: instructionsMessage2, image: Image("flexion"))
                    InstructionPoint(text: instructionsMessage3, image: Image("extension"))
                    InstructionPoint(text: instructionsMessage4, image: Image("initial_position"))
                }
                    
                VStack(spacing: 16) {
                    InstructionHeadline(headline: "Editing Instructions")
                    InstructionPoint(text: videoEditingInstructions1, image: Image("Edit"))
                    InstructionPoint(text: videoEditingInstructions2, image: Image("TrimStart"))
                    InstructionPoint(text: videoEditingInstructions3, image: Image("TrimEnd"))
                    InstructionPoint(text: videoEditingInstructions4, image: Image("CropStarts"))
                    InstructionPoint(text: videoEditingInstructions5, image: Image("CropMid"))
                    InstructionPoint(text: videoEditingInstructions6, image: Image("CropEnd"))
                }
                
                VStack(spacing: 8) {
                    BulletedList(headline: "How to improve your video", text: howToImprove)
                }
                
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
    }
}

// MARK: - InstructionPoint
struct InstructionPoint: View {
    
    // MARK: Stored Instance Properties
    let text: String
    let image: Image
    
    // MARK: Body
    var body: some View {
        // headline
        VStack(spacing: 8) {
            Text(self.text)
                .font(.body)
            self.image
                .resizable()
                .scaledToFit()
                .cornerRadius(5)
            
            
        }
    }
}

// MARK: - InstructionHeadline
struct InstructionHeadline: View {
    
    // MARK: Stored Instance Properties
    let headline: String
    
    // MARK: Body
    var body: some View {
        // headline
        Text(self.headline)
            .font(.headline)
            .padding()
    }
}

// MARK: - BulletedList
struct BulletedList: View {
    
    // MARK: Stored Instance Properties
    private let headline: String
    private let text: [String]
    
    // MARK: Initializers
    init(headline: String, text: [String]) {
        self.headline = headline
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        
        VStack(spacing: 8) {
            
            // headline
            Text(self.headline)
                .font(.headline)
            
            VStack(alignment: .leading) {
                
                // bulletpoints
                ForEach(self.text, id: \.self) { bulletpoint in
                    
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .padding(.top, 7.5)
                        
                        Text(bulletpoint)
                            .font(.body)
                    }
                }
            }
        }
    }
}

// MARK: - Previews
struct InstructionContent_Previews: PreviewProvider {
    static var previews: some View {
        InstructionContent()
    }
}
