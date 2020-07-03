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
    
    // MARK: Binding Instance Properties
    @Binding var show: Bool
    
    // MARK: Stored Instance Properties
    let displayDismissButton: Bool
    let width: CGFloat
    // swiftlint:disable line_length
    
    //solution from https://stackoverflow.com/questions/59624838/swiftui-tappable-subtext
    struct infoMessage: View {
        
        var body: some View {
            
            HStack {
                
                Text("""

The values you see are the maximum and minumum range of motion angle you were able to reach by straigthening and bending your joint.

            For the PDF sent to your doctor we will translate your values into the "Neutral-Zero-Method", which is an orthopedic index for measuring joint mobility.

            Your mobility will be expressed in 3 angle degrees originating from the neutral-zero position, which is defined for each joint specifically.

            Taking your knee as an example, the neutral-zero position would be a 180 degree straight joint.

            Especially during recovery, you might not reach the neutral-zero position, which will be shown in the PDF as well, depending which three values are written in the PDF.

            Hint: If the middle number displays 0, you are able to reach the neutral zero position for the respective joint. :-)

            Disclaimer: Please note that Range of Motion values are highly individually dependent on your physical conditions and can only be correctly interpreted by a professional. Do not use these values to diagnose yourself.

            If your interested in how exactly the values are read by a doctor please visit:
""")
                
                Text("link")
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        let url = URL.init(string: "https://flexikon.doccheck.com/de/Neutral-Null-Methode")
                        guard let infoURL = url, UIApplication.shared.canOpenURL(infoURL) else { return }
                        UIApplication.shared.open(infoURL)
                }
            }
        }
    }
    
    //(Quelle: https://flexikon.doccheck.com/de/Neutral-Null-Methode)
    
    // swiftlint:enable line_length
    
    // MARK: Body
    var body: some View {
        VStack {

            Text("What are my values?").font(.title)
                        ScrollView {
                // TO DO: hier irgendwie die struct einbinden, ich weiß nicht wie das geht
                Text(infoMessage)
                    .padding()
            }
            if self.displayDismissButton {
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Dismiss")
                }.padding(.top)
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
        InfoView(
            show: .constant(false),
            displayDismissButton: false,
            width: 350
        )
    }
}
