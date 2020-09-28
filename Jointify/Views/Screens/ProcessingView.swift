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
    @State private var analysisFailed: Bool = false
    
    @State private var poseNetPredictionOutputArray: [PoseNetPredictionOutput] = []
    
    // MARK: Stored Instance Properties
    private var poseNet: PoseNet
    private let errorMessage = """
        Unfortunately, the analysis failed.
        Please follow the instructions carefully when preparing your video for the analysis and try again.
        NOTE: In the future, we want to show you a detailed reason for the failure.
    """
    private let acceptedFramesThreshold: Double = 0.55
    let chosenSide: Side
    let chosenJointCase: JointCase
    
    // MARK: Initializers
    init(videoUrl: Binding<NSURL?>, chosenSide: Side, chosenJointCase: JointCase) {
        self._videoUrl = videoUrl
        self.chosenSide = chosenSide
        self.chosenJointCase = chosenJointCase
        self.poseNet = PoseNet(side: self.chosenSide, jointCase: self.chosenJointCase)
    }
    
    // MARK: Body
    var body: some View {
        
        // GeometryReader to allow for percentage alignments
        GeometryReader { geometry in
            
            // Outer VStack
            VStack(spacing: 16.0) {
                
                // pass analysed images further
                if self.measurement != nil {
                    NavigationLink(
                        destination: VideoResultView(
                            poseNetPredictionOutputArray: self.$poseNetPredictionOutputArray,
                            measurement: self.measurement!,
                            poseNet: self.poseNet
                        )
                        // hide the navigation bar of the VideoResultView, too
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$finishedProcessing) { EmptyView() }
                }
                
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
                    failed: self.$analysisFailed,
                    maxWidth: 150,
                    height: 20
                )
            }.padding(.bottom, 32)
                
                // start the analysis when screen is loaded
                .onAppear(perform: self.analysis)
                
                .alert(isPresented: self.$analysisFailed) {
                    Alert(
                        title: Text("Please try again"),
                        message: Text(self.errorMessage),
                        dismissButton: .cancel(Text("Try again")) {
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                                .toWelcomeView()
                        }
                    )
            }
        }
    }
    
    // MARK: Private Instance Methods
    /// starts the PoseNet analysis on the loaded video(url)
    private func analysis() {
        
        guard let videoUrl = self.videoUrl else {
            print("videoUrl could not be retrieved")
            return
        }
        
        let videoAsImageArray: [UIImage] = self.transformVideoToImageArray(videoUrl: videoUrl)
        
        self.analyseVideo(frames: videoAsImageArray) { analysisResult  in
            
            // work with the success and the passed through Measurement here
            switch analysisResult {
            case .success(let measurement):
                
                // save to DataHandler
                DataHandler.saveNewMeasurement(measurement: measurement)
                self.measurement = measurement
                
                // trigger navigation to VideoResultView
                self.finishedProcessing.toggle()
                
            case .failure(let error):
                
                // work with the error type here
                switch error {
                case .acceptanceCriteriaFailed:
                    self.analysisFailed.toggle()
                default:
                    print("Not implemented yet")
                }
            }
        }
    }
    
    /// From https://stackoverflow.com/questions/42665271/swift-get-all-frames-from-video
    /// takes the NSURL of a video and converts it to an UIImage array by taking frame by frame
    private func transformVideoToImageArray(videoUrl: NSURL) -> [UIImage] {
        print("Getting frames from \(videoUrl)")
        
        var frames: [UIImage] = []
        
        let asset: AVAsset = AVAsset(url: videoUrl as URL)
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        // change frequency of frame creation here by making it a float
        for index in stride(from: 0.0, to: duration, by: 1) {
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
    private func analyseVideo(
        frames: [UIImage],
        completion: @escaping (Result<Measurement, PoseNetAnalysisError>) -> Void) {
        
        // total number of frames
        self.total = frames.count
        
        var qualityAssessmentFailed = false
        // instantiate PoseNet model
        print("Chosen side: \(self.chosenSide)")
        print("Chosen joint case: \(self.chosenJointCase)")
        
        // let model run asnyc
        let queue = DispatchQueue(label: "ml-queue", qos: .utility)
        queue.async {
            
            print("Starting PoseNet analysis")
            
            for (frameCount, frame) in frames.enumerated() {
                print("Analysing frame \(frameCount+1)/\(frames.count)")
                
                // let model run over current frame
                let poseNetPredictionOutput = self.poseNet.predict(frame)
                
                // Only append measurement frame if it fulfills quality criteria
                // This functionality was commented out for debugging
                /*if poseNetPredictionOutput.outputQualityAcceptable {
                    self.acceptedFramesCounter += 1
                    self.poseNetPredictionOutputArray.append(poseNetPredictionOutput)
                }*/
                
                self.progress += 1
                
                // This was added for debugging
                self.poseNetPredictionOutputArray.append(poseNetPredictionOutput)
                
                self.remainingFrames = self.total - self.progress
                
                ///Provide early exit possibility if acceptedFramesThreshold cannot be reached anymore
                /// -> too little frames were of sufficient quality
                /*if (Double(self.acceptedFramesCounter + self.remainingFrames)
                    / Double(self.total)) < self.acceptedFramesThreshold {
                    qualityAssessmentFailed = true
                    break
                }*/
            }
            
            // Check if video could be analyzed or if the qualitity assessment failed
            if qualityAssessmentFailed {
                
                print("Video could not be anaylzed successfully")
                // TODO: Improve the failure reasons with Niki
                // failure when (...)
                completion(.failure(.acceptanceCriteriaFailed))
                
            } else {
                
                // Find frames with min and max degree and only draw joints on these frames
                guard let poseNetMin = self.findFrameWithDegree(self.poseNetPredictionOutputArray, .minimum),
                    let poseNetMax = self.findFrameWithDegree(self.poseNetPredictionOutputArray, .maximum) else {
                        print("Minimium or maximum degree could not be obtained")
                        return
                }
                
                let drawnMinImage = self.poseNet.show(frame: poseNetMin.image,
                                                 pose: poseNetMin.pose)
                let drawnMaxImage = self.poseNet.show(frame: poseNetMax.image,
                                                 pose: poseNetMax.pose)
                
                guard let finalMinImage = drawnMinImage.cutToWidthFromLeft(poseNetMin.originalFrameSize.width),
                    let finalMaxImage = drawnMaxImage.cutToWidthFromLeft(poseNetMax.originalFrameSize.width) else {
                        print("Error. Image could not be cut to original width.")
                        return
                }
                
                // successfully derived a Measurement instance
                let measurement = Measurement(
                    date: Date(),
                    minROMFrame: MeasurementFrame(degree: poseNetMin.degree, image: finalMinImage),
                    maxROMFrame: MeasurementFrame(degree: poseNetMax.degree, image: finalMaxImage)
                )
                
                // success when done
                print("Done with PoseNet analysis")
                completion(.success(measurement))
            }
        }
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
}

// MARK: - Previews
struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(videoUrl: .constant(nil), chosenSide: .right, chosenJointCase: .knee)
    }
}
