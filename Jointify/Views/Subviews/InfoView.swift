//
//  InfoView.swift
//  Jointify
//
//  Created by user175619 on 6/25/20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InfoView
struct InfoView: View {
    
    // MARK: Stored Instance Properties
    let width: CGFloat
    // swiftlint:disable line_length
    private let infoMessage = """
    Your values are being measured by the "Neutral-Null-Methode", which is an orthopedic index for measuring joint mobility.

    Your mobility will be expressed in 3 angle degrees originating from the neutral-zero position, which is defined for each joint specifically. The neutral-zero position is what we referred to as your starting position earlier.

    From this position Jointify measures your maximum Range of Motion in both directions and sends it to your doctor, who is then able to determine, if your range of motion is impaired.

    Values:
    1) Movement away from body
    2) 0, if Neutral-Zero is achieved
    3) Movement towards body

    Disclaimer: Please note that Range of Motion values are highly individually dependent on your physical conditions and can only be correctly interpreted by a professional. Do not use these values to diagnose yourself.
    (Jointify haftet nicht?)

    (Quelle: https://flexikon.doccheck.com/de/Neutral-Null-Methode)
    """
    // swiftlint:enable line_length
    
    // MARK: Body
    var body: some View {
        VStack {
            Text("What are my values?").font(.title)
            
            ScrollView {
                Text(infoMessage)
                    .padding()
            }
        }
        .padding(.vertical)
        .frame(width: width)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 8)
        
    }
}

// MARK: - Previews
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(width: 30)
    }
}
