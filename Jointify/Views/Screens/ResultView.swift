//
//  ResultView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ResultView
struct ResultView: View {
    
    // MARK: State Instance Properties
    @State private var createReportButtonPressed: Bool = false
    @State private var homeButtonPressed: Bool = false

    // MARK: Stored Instance Properties
    let measurement: Measurement
    let mockedPreviousMinValue: Int = -45
    let mockedPreviousMaxValue: Int = 80
    
    // MARK: Body
    var body: some View {
        VStack {

            Text("The video was analysed:")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            
            Spacer().frame(height: 50)
            
            VStack(spacing: 8.0) {
                Text("Your measurements:").font(.title)
                
                VStack {
                    HStack(spacing: 16.0) {
                        Text("Max value: \(measurement.maxROM)°")
                        Text("Min value: \(measurement.minROM)°")
                    }
                    HStack(spacing: 16.0) {
                        Text("previous: \(mockedPreviousMaxValue)°")
                            .foregroundColor(Color.gray)
                        Text("previous: \(mockedPreviousMinValue)°")
                            .foregroundColor(Color.gray)
                    }
                }
                
            }
            
            Spacer().frame(height: 50)

            HStack {
                DefaultButton(action: {
                    // back home
                }) {
                    Text("Do it again")
                }
                Spacer(minLength: 16)
                DefaultButton(action: {
                    // create PDF and open Mail-app here
                }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Report")
                    }
                }
            }.padding(.horizontal, 60)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        
        ResultView(
            measurement: Measurement(
                date: Date(),
                videoUrl: nil,
                frames: []
            )
        )
    }
}
