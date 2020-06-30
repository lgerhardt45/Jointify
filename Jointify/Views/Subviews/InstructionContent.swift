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
    private let instructionsMessage = [
        "Find a suitable spot with as little visual distraction as possible. The analysis works best in front of a plain white wall.",
        "Place your mobile phone roughly 3 meters away from you on a object which is at least 60 centimetres high (e.g. a chair). It is important that your whole body is in the centre of the picture, since your video will be analysed in square format.",
        "Start the recording.",
        "Get into the initial position as indicated in the exemplary video.",
        "Move your joint as shown in the video. Make sure that all of your body parts are visible all the time.",
        "Stop the recording.",
        "Edit the recording according to the criteria defined below and upload it in the app."
    ]
    
    let videoEditingRequirements = [
        "Make sure that you stand in the centre of the video while showing your whole body.",
        "The first frame should be the initial position as indicated in the example video. The same holds for the last frame. Please cut the video accordingly."
    ]
    
    let privacyDisclaimer =
    "No submitted videos will be saved or leave your phone in any way. All these restrictions are simply needed to ensure correct measurement results."
    
    let howToImprove = [
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
                BulletedList(headline: "Recording Instructions",
                             text: instructionsMessage)
                
                BulletedList(headline: "Video Editing Requirements",
                             text: videoEditingRequirements)
                
                BulletedList(headline: "How to improve the recording",
                             text: howToImprove)
                
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
