//
//  ProcessingView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI
import AVKit

// MARK: - ProcessingView
struct ProcessingView: View {
    
    // MARK: Binding Instance Properties
    @Binding var videoUrl: NSURL?
    
    // MARK: State Instance Propoerties
    @State private var finishedProcessing: Bool = false
    @State private var timeRemaining = 3.0 // TODO: remove when done
    @State private var progressDots = ""   // TODO: remove when done
    @State private var measurement: Measurement?
    
    // MARK: Stored Instance Properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // TODO: remove when done
    
    // MARK: Body
    var body: some View {
        VStack {
            VStack {
                
                // pass analysed images further
                NavigationLink(destination:
                    VideoResultView(measurement: measurement),
                               isActive: self.$finishedProcessing) { EmptyView() }
                Text("Dein Bild wird analysiert")
                Text(progressDots)
            }
            .onAppear(perform: {
                guard let videoUrl = self.videoUrl else {
                    return
                }
                
                let videoAsImageArray: [UIImage] = self.transformVideoToImageArray(videoUrl: videoUrl)
                
                let measurementFrames: [MeasurementFrame] = self.analyseVideo(frames: videoAsImageArray)
                
                self.measurement = Measurement(date: Date(), videoUrl: videoUrl, frames: measurementFrames)
                
                // when finished processing: ONLY TOGGLE WHEN
                // MEASUREMENT IS DONE, because force unwrapping when sending it
                // TODO fix the force unwrapping
                // self.finishedProcessing.toggle()
            })
            
        }.onReceive(timer) { _ in
            if self.timeRemaining >= 0 {
                self.timeRemaining -= 1
                self.incrementProgressDot()
            } else {
                self.finishedProcessing.toggle()
                self.timer.upstream.connect().cancel()
            }
        }
        
    }
    
    // MARK: Private Instance Methods
    /// From https://stackoverflow.com/questions/42665271/swift-get-all-frames-from-video
    /// takes the NSURL of a video and converts it to an UIImage array by taking frame by frame (one per second)
    private func transformVideoToImageArray(videoUrl: NSURL) -> [UIImage] {
        
        var frames: [UIImage]
        guard let videoUrl = self.videoUrl else {
            return []
        }
        
        let asset: AVAsset = AVAsset(url: videoUrl as URL)
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        frames = []
        for index: Int in 0 ..< Int(duration) {
            let time: CMTime = CMTimeMakeWithSeconds(Float64(index), preferredTimescale: 600)
            let image: CGImage
            do {
                try image = generator.copyCGImage(at: time, actualTime: nil)
                frames.append(UIImage(cgImage: image))
            } catch {
                return []
            }
        }
        
        return frames
    }
    
    /// runs the machine learning model on an array of UIImages and returns an array of MeasurementFrame instances
    private func analyseVideo(frames: [UIImage]) -> [MeasurementFrame] {
        let chosenSide = "right" // Niki go ahead and just use the left only
        
        // Model
        let poseNet = PoseNet(side: .right)
        
        var returnMeasurementFrames: [MeasurementFrame] = []
        
        for frame in frames {
            
            let drawnImage = poseNet.predict(frame)
            
            returnMeasurementFrames.append(
                MeasurementFrame(
                    degree: poseNet.calcAngleBetweenJoints(chosenSide),
                    image: drawnImage)
            )
        }
        
        // for image in frames -> run -> returnMeasurementFrames.append(...)
        return returnMeasurementFrames
    }
    
    /// animates a loading text through 3 dots
    private func incrementProgressDot() {
        // TODO: Remove when done with analysis
        if progressDots.count >= 3 {
            progressDots = "."
        } else {
            progressDots.append(".")
        }
    }
}

// MARK: Previews
struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(videoUrl: .constant(nil))
    }
}
