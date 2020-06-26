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
    let measurement: Measurement
    
    // MARK: Body
    var body: some View {
        
        // GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            // Outer VStack
            VStack(spacing: 16) {
                
                // 20% for the Header
                LogoAndHeadlineView(
                    headline: "Done!",
                    showLogo: true,
                    allowToPopView: false,
                    height: geometry.size.height * 0.2
                )
                
                // subheadline
                SubHeadline(subheadline: "Your video was analyzed succesfully.", width: geometry.size.width / 2.0)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if self.measurement.frames.isEmpty {
                            Text("Frames could not be analysed 😔")
                        } else {
                            ForEach(self.measurement.frames, id: \.self) { frame in
                                VStack(spacing: 8) {
                                    // sorry for the force unwrap
                                    Image(uiImage: UIImage(data: frame.image) ?? UIImage(systemName: "heart.fill")!)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(5)
                                    Text("Degree: \(Int(round(frame.degree)))°")
                                }
                            }
                        }
                    }
                }
                
                // Button to ResultView
                NavigationLink(
                    destination: ResultView(measurement: self.measurement)
                        // hide the navigation bar on the ResultView, too
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$goToResultView) {
                        DefaultButton(action: {
                            self.goToResultView.toggle()
                        }) {
                            Text("Done")
                                .frame(width: geometry.size.width / 3.0)
                        }
                }
            }.padding(.bottom, 32)
                .padding(.horizontal)
        }
    }
}

// MARK: - Previews
struct VideoResultView_Previews: PreviewProvider {
    static var previews: some View {
        VideoResultView(
            measurement: Measurement(
                date: Date(),
                frames: [
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!),
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!),
                    MeasurementFrame(degree: 0, image: UIImage(named: "placeholder")!)
                ]
        ))
    }
}
