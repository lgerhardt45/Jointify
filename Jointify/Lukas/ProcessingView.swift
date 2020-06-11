//
//  ProcessingView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ProcessingView
struct ProcessingView: View {
    
    // MARK: Binding Instance Properties
    @Binding var videoAsImageArray: [UIImage]
    
    // MARK: State Instance Propoerties
    @State private var timeRemaining = 5.0
    @State private var finishedProcessing: Bool = false
    @State private var progressDots = ""
    
    // MARK: Stored Instance Properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: Body
    var body: some View {
        VStack(spacing: 80.0) {
            // pass analysed images to Inst
            NavigationLink(destination: ResultView(), isActive: self.$finishedProcessing) {
                Text("")
            }
            HStack {
                Text("Dein Bild wird analysiert")
                Text(progressDots)
            }
            
        }
        .onAppear(perform: {
            self.analyseVideo()
        })
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.incrementProgressDot()
            } else {
                self.finishedProcessing = true
            }
        }
    }
    
    // MARK: Private Instance Methods
    /// does the machine learning analysis on the images and updates them
    func analyseVideo() {
        
        // take the videoAsImageArray and do the magic
        // finishedProcessing = true löst den NavigationLink aus
    }
    
    func incrementProgressDot() {
        if progressDots.count >= 3 {
            progressDots = "."
        } else {
            progressDots.append(".")
        }
    }
}
