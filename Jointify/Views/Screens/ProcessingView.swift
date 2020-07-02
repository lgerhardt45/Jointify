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
    @State private var remainingFrames: Int = 0
    @State private var finishedProcessing: Bool = false
    @State private var measurement: Measurement?
    @State private var acceptedFramesCounter = 0
    
    // MARK: Stored Instance Properties
    private let acceptedFramesThreshold: Double = 0.45
    let chosenSide: Side
    
    // MARK: Body
    var body: some View {
        
        // GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            // Outer VStack
            VStack(spacing: 16.0) {
                
                // pass analysed images further
                NavigationLink(
                    destination: VideoResultView(measurement: self.measurement ?? Measurement())
                        // hide the navigation bar of the VideoResultView, too
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$finishedProcessing) { EmptyView() }
                
                // 20% for the headline
                LogoAndHeadlineView(
                    headline: "Analyzing...",
                    showLogo: true,
                    allowToPopView: false,
                    height: geometry.size.height * 0.20
                )
                
                InfoView(show: .constant(true),
                         displayDismissButton: false,
                         width: geometry.size.width * 0.9)
                    .padding(.vertical)
                
                ProgressBar(
                    currentProgress: self.$progress,
                    total: self.$total,
                    maxWidth: 150,
                    height: 20
                )
            }.padding(.bottom, 32)
                
                // start the analysis when screen is loaded
                .onAppear(perform: {
                    guard let videoUrl = self.videoUrl else {
                        print("videoUrl could not be retrieved")
                        return
                    }
                    
                    let videoAsImageArray: [UIImage] = self.transformVideoToImageArray(videoUrl: videoUrl)
                    
                    // TODO: Make this a Result<AnalysisResult, AnalysisErro>
                    self.analyseVideo(frames: videoAsImageArray) { (drawnFrames)  in
                        
                        if let maxROMFrame = drawnFrames.first,
                            let minROMFrame = drawnFrames.last {
                            
                            // set the measurement property when done
                            let measurement = Measurement(
                                date: Date(),
                                minROMFrame: minROMFrame,
                                maxROMFrame: maxROMFrame
                            )
                            
                            // save to DataHandler
                            DataHandler.saveNewMeasurement(measurement: measurement)
                            self.measurement = measurement
                            
                        } else {
                            self.measurement = nil
                        }
                        
                        // trigger navigation to VideoResultView
                        self.finishedProcessing.toggle()
                    }
                })
        }
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
        for index in stride(from: 0.0, to: duration, by: 0.33) {
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
    
    /// Find frames with maximum or minimum degree
    private func findFrameWithDegree(_ poseNetPredictionOutputArray: [PoseNetPredictionOutput],
                                     _ value: ExtremeValue) -> PoseNetPredictionOutput? {
        var poseNetPredictionOutputDegree: PoseNetPredictionOutput?
        var degree: Float
        
        switch value {
        case .maximum:
            degree = 0
            for poseNetPredictionOutput in poseNetPredictionOutputArray where poseNetPredictionOutput.degree > degree {
                poseNetPredictionOutputDegree = poseNetPredictionOutput
                degree = poseNetPredictionOutput.degree
            }
        case .minimum:
            degree = 361
            for poseNetPredictionOutput in poseNetPredictionOutputArray where poseNetPredictionOutput.degree < degree {
                poseNetPredictionOutputDegree = poseNetPredictionOutput
                degree = poseNetPredictionOutput.degree
            }
        }
        
        return poseNetPredictionOutputDegree
    }
    
    /// runs the machine learning model on an array of UIImages and returns an array of MeasurementFrame instances
    private func analyseVideo(frames: [UIImage], completion: @escaping ([MeasurementFrame]) -> Void) {
        // total number of frames
        self.total = frames.count
        
        var qualityAssessmentFailed = false
        // instantiate PoseNet model
        print("Chosen side: \(self.chosenSide)")
        let poseNet = PoseNet(side: self.chosenSide)
        
        // let model run asnyc
        let queue = DispatchQueue(label: "ml-queue", qos: .utility)
        queue.async {
            
            print("Starting PoseNet analysis")
            var returnMeasurementFrames: [MeasurementFrame] = []
            var poseNetPredictionOutputArray: [PoseNetPredictionOutput] = []
            
            for (frameCount, frame) in frames.enumerated() {
                print("Analysing frame \(frameCount+1)/\(frames.count)")
                
                // let model run over current frame
                let poseNetPredictionOutput = poseNet.predict(frame)
                
                // Only append measurement frame if it fulfills quality criteria
                if poseNetPredictionOutput.outputQualityAcceptable {
                    self.acceptedFramesCounter += 1
                    poseNetPredictionOutputArray.append(poseNetPredictionOutput)
                }
                
                self.progress += 1
                
                self.remainingFrames = self.total - self.progress
                
                ///Provide early exit possibility if acceptedFramesThreshold cannot be reached anymore
                /// -> too little frames were of sufficient quality
                if (Double(self.acceptedFramesCounter + self.remainingFrames)
                    / Double(self.total)) < self.acceptedFramesThreshold {
                    qualityAssessmentFailed = true
                    break
                }
            }
            
            // Check if video could be analyzed or if the qualitity assessment failed
            if qualityAssessmentFailed {
                
                print("Video could not be anaylzed successfully")
                completion(returnMeasurementFrames)
                
            } else {
                
                // Find frames with min and max degree and only draw joints on these frames
                 guard let poseNetMax = self.findFrameWithDegree(poseNetPredictionOutputArray, .maximum),
                     let poseNetMin = self.findFrameWithDegree(poseNetPredictionOutputArray, .minimum) else {
                         print("Minimium or maximum degree could not be obtained")
                         return
                 }
                 
                 // Draw joints on frame with max degree
                 returnMeasurementFrames.append(
                     MeasurementFrame(
                         degree: poseNetMax.degree,
                         image: poseNet.show(poseNetMax.image, poseNetMax.pose)
                     )
                 )
                
                 // Draw joints on frame with min degree
                  returnMeasurementFrames.append(
                    MeasurementFrame(
                        degree: poseNetMin.degree,
                        image: poseNet.show(poseNetMin.image, poseNetMin.pose)
                    )
                )
                 
                 // send when done
                 print("Done with PoseNet analysis")
                 completion(returnMeasurementFrames)
            }
        }
    }
}

// MARK: - Previews
struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(videoUrl: .constant(nil), chosenSide: .right)
    }
}
