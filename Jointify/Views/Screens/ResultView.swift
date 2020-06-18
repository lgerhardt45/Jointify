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
    // TODO: change to Measurement
    let minValue: Int = -55
    let maxValue: Int = 90
    let previousMinValue: Int = -45
    let previousMaxValue: Int = 80
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            Logo()
            Spacer().frame(height: 86)
            Text("Your Results")
                .font(.largeTitle)
                .font(.system(size:48))
            
            Spacer().frame(height: 50)
            
            VStack(spacing: 8.0) {
                Text("Your measurements:").font(.title)
                
                VStack {
                    HStack(spacing: 16.0) {
                        Text("Max value: \(maxValue)°")
                        Text("Min value: \(minValue)°")
                    }
                    HStack(spacing: 16.0) {
                        Text("previous: \(previousMaxValue)°")
                            .foregroundColor(Color.gray)
                        Text("previous: \(previousMinValue)°")
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
        }.padding(.all)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
