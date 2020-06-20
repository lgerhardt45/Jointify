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
    @State private var progress: Int = 0
    @State private var total: Int = 0
    @State private var finishedProcessing: Bool = false
    @State private var measurement: Measurement?
    
    // MARK: Body
    var body: some View {
        
        //GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            // Outer VStack
            VStack(spacing: 16.0) {
                
                // pass analysed images further
                NavigationLink(destination:
                    VideoResultView(measurement: self.measurement),
                               isActive: self.$finishedProcessing) { EmptyView() }
                
                // 20% for the headline
                LogoAndHeadlineView(headline: "Analyzing", showLogo: true, height: geometry.size.height * 0.20)
                
                // subheadline
                SubHeadline(subheadline: "Please wait...", width: geometry.size.width / 2.0)
                
                //Placeholder
                Text("Insert fun facts and info stuff here")
                
                Spacer()
                
                ProgressBar(
                    currentProgress: self.$progress,
                    total: self.$total,
                    maxWidth: 150,
                    height: 20)
            }
                // start the analysis when screen is loaded
                .onAppear(perform: {
                    guard let videoUrl = self.videoUrl else {
                        print("videoUrl could not be retrieved")
                        return
                    }
                    
                    let videoAsImageArray: [UIImage] = self.transformVideoToImageArray(videoUrl: videoUrl)
                    
                    self.analyseVideo(frames: videoAsImageArray) { (drawnFrames)  in
                        
                        // set the measurement property when done
                        self.measurement = Measurement(
                            date: Date(),
                            videoUrl: videoUrl,
                            frames: drawnFrames
                        )
                        
                        // trigger navigation to VideoResultView
                        self.finishedProcessing.toggle()
                    }
                })
        }.padding(.bottom)
    }
    
    // MARK: Private Instance Methods
    /// From https://stackoverflow.com/questions/42665271/swift-get-all-frames-from-video
    /// takes the NSURL of a video and converts it to an UIImage array by taking frame by frame (one per second)
    private func transformVideoToImageArray(videoUrl: NSURL) -> [UIImage] {
        print("Getting frames from \(videoUrl)")
        
        var frames: [UIImage] = []
        
        let asset: AVAsset = AVAsset(url: videoUrl as URL)
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        // change frequency of frame creation here by making it a float
        for index: Int in 0 ..< Int(duration) {
            let time: CMTime = CMTimeMakeWithSeconds(Float64(index), preferredTimescale: 600)
            let image: CGImage
            do {
                try image = generator.copyCGImage(at: time, actualTime: nil)
                frames.append(UIImage(cgImage: image))
            } catch {
                print("Failed to retrieve frames from \(videoUrl)")
                return []
            }
        }
        
        print("\(frames.count) frames created")
        return frames
    }
    
    /// runs the machine learning model on an array of UIImages and returns an array of MeasurementFrame instances
    private func analyseVideo(frames: [UIImage], completion: @escaping ([MeasurementFrame]) -> Void) {
        
        self.total = frames.count
        
        // instantiate PoseNet model
        let poseNet = PoseNet(side: .right)
        
        // let model run asnyc
        let queue = DispatchQueue(label: "ml-queue", qos: .utility)
        queue.async {
            
            print("Starting PoseNet analysis")
            
            var returnMeasurementFrames: [MeasurementFrame] = []
            
            for (frameCount, frame) in frames.enumerated() {
                
                print("Analysing frame \(frameCount)/\(frames.count)")
                
                let drawnImage = poseNet.predict(frame)
                
                returnMeasurementFrames.append(
                    MeasurementFrame(
                        degree: poseNet.calcAngleBetweenJoints(),
                        image: drawnImage
                    )
                )
                self.progress += 1
                
            }
            
            // send when done
            print("Done with PoseNet analysis")
            completion(returnMeasurementFrames)
        }
    }
}

// MARK: Previews
struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(videoUrl: .constant(nil))
    }
}
