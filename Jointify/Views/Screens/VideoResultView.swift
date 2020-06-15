//
//  VideoResultView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 14.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - VideoResultView
struct VideoResultView: View {
    
    // MARK: State Instance Properties
    @State var goToResultView: Bool = false
    
    // MARK: Stored Instance Properties
    let measurement: Measurement?
    
    // MARK: Body
    var body: some View {
        VStack {
            
            Text("The frames (scroll):")
            ScrollView {
                VStack(spacing: 16) {
                        ForEach(measurement?.frames ?? [], id: \.self) { frame in
                            VStack(spacing: 8) {
                                Image(uiImage: frame.image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                                Text("Degrees: \(frame.degree)")
                        }
                    }
                }
            }
            
            NavigationLink(destination: ResultView(), isActive: self.$goToResultView) {
                DefaultButton(action: {
                    self.goToResultView.toggle()
                }) {
                    Text("Done")
                }
            }
        }
        .padding(.all)
    }
}

struct VideoResultView_Previews: PreviewProvider {
    static var previews: some View {
        VideoResultView(
            measurement: Measurement(
                date: Date(),
                videoUrl: nil,
                frames: [
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!),
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!),
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!)
                ]
        ))
    }
}
