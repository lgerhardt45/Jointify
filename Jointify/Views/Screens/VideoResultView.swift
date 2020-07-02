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
                        
                        // min
                        VStack(spacing: 8) {
                            // sorry for the force unwrap
                            Image(
                                uiImage: UIImage(data: self.measurement.minROMFrame.image)
                                    ?? UIImage(systemName: "heart.fill")!
                            )
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(5)
                            Text("Minimum degree: \(Int(round(self.measurement.minROMFrame.degree)))°")
                        }
                        
                        // max
                        VStack(spacing: 8) {
                            // sorry for the force unwrap
                            Image(
                                uiImage: UIImage(data: self.measurement.maxROMFrame.image)
                                    ?? UIImage(systemName: "heart.fill")!
                            )
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(5)
                            Text("Maximum degree: \(Int(round(self.measurement.maxROMFrame.degree)))°")
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
            measurement: DataHandler.mockMeasurements[0]
        )
    }
}
