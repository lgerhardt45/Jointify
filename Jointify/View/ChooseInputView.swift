//
//  ChooseInputView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 03.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - ChooseInputView
struct ChooseInputView: View {
    @Binding var isNavigationBarHidden: Bool
    @State var image: Image?
    @State var isImagePickerShowing: Bool = false
    @State var sourceType: Int // if 0 camera is selected, if 1 gallery
    @State var isShowingSelectionButton: Bool = true
    // if this is changed, the "your selected image" screen will be loaded in the same view
    @State var imagePickerCanceled: Bool = false
    // this helps preventing loading the "your selected image" screen, if the image picker is canceled
    @State var isShowingAnalyzedImageView: Bool = false
    
    //let model = PoseNetMobileNet075S16FP16().model
    
    let model = PoseNetMobileNet100S8FP16().model
    
    let poseNet = PoseNet()
    
    let modelInputSize = CGSize(width: 513, height: 513)
    
    //var algorithm: Algorithm = .multiple

    /// The set of parameters passed to the pose builder when detecting poses.
    var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    @State var finalImage = UIImage(named: "surgery") //UIImage?

    /// The PoseNet model's output stride.
    ///
    /// Valid strides are 16 and 8 and define the resolution of the grid output by the model. Smaller strides
    /// result in higher-resolution grids with an expected increase in accuracy but require more computation. Larger
    /// strides provide a more coarse grid and typically less accurate but are computationally cheaper in comparison.
    ///
    /// - Note: The output stride is dependent on the chosen model and specified in the metadata. Other variants of the
    /// PoseNet models are available from the Model Gallery.
    let outputStride = 8
    
    /// A data structure used to describe a visual connection between two joints.
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }

    /// An array of joint-pairs that define the lines of a pose's wireframe drawing.
    // IMPORTANT MAYBE NEED TO ADD static before let!!!!
    /// TODO: validate
    //
    let jointSegments = [
        // The connected joints that are on the left side of the body.
        JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        // The connected joints that are on the right side of the body.
        JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        JointSegment(jointA: .leftHip, jointB: .rightHip)
    ]

    /// The width of the line connecting two joints.
    var segmentLineWidth: CGFloat = 2
    /// The color of the line connecting two joints.
    var segmentColor: UIColor = UIColor.systemTeal
    /// The radius of the circles drawn for each joint.
    var jointRadius: CGFloat = 4
    /// The color of the circles drawn for each joint.
    var jointColor: UIColor = UIColor.systemPink

    // MARK: - Rendering methods

    /// Returns an image showing the detected poses.
    ///
    /// - parameters:
    ///     - poses: An array of detected poses.
    ///     - frame: The image used to detect the poses and used as the background for the returned image.
    func show(poses: [Pose], on frame: CGImage) {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()

        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)

        let dstImage = renderer.image { rendererContext in
            // Draw the current frame as the background for the new image.
            draw(image: frame, in: rendererContext.cgContext)

            for pose in poses {
                // Draw the segment lines.
                for segment in jointSegments {
                    let jointA = pose[segment.jointA]
                    let jointB = pose[segment.jointB]

                    guard jointA.isValid, jointB.isValid else {
                        continue
                    }

                    drawLine(from: jointA,
                             to: jointB,
                             in: rendererContext.cgContext)
                }

                // Draw the joints as circles above the segment lines.
                for joint in pose.joints.values.filter({ $0.isValid }) {
                    draw(circle: joint, in: rendererContext.cgContext)
                }
            }
        }

        finalImage = dstImage
    }

    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    func draw(image: CGImage, in cgContext: CGContext) {
        cgContext.saveGState()
        // The given image is assumed to be upside down; therefore, the context
        // is flipped before rendering the image.
        cgContext.scaleBy(x: 1.0, y: -1.0)
        // Render the image, adjusting for the scale transformation performed above.
        let drawingRect = CGRect(x: 0, y: -image.height, width: image.width, height: image.height)
        cgContext.draw(image, in: drawingRect)
        cgContext.restoreGState()
    }

    /// Draws a line between two joints.
    ///
    /// - parameters:
    ///     - parentJoint: A valid joint whose position is used as the start position of the line.
    ///     - childJoint: A valid joint whose position is used as the end of the line.
    ///     - cgContext: The rendering context.
    func drawLine(from parentJoint: Joint,
                  to childJoint: Joint,
                  in cgContext: CGContext) {
        cgContext.setStrokeColor(segmentColor.cgColor)
        cgContext.setLineWidth(segmentLineWidth)

        cgContext.move(to: parentJoint.position)
        cgContext.addLine(to: childJoint.position)
        cgContext.strokePath()
    }

    /// Draw a circle in the location of the given joint.
    ///
    /// - parameters:
    ///     - circle: A valid joint whose position is used as the circle's center.
    ///     - cgContext: The rendering context.
    private func draw(circle joint: Joint, in cgContext: CGContext) {
        cgContext.setFillColor(jointColor.cgColor)

        let rectangle = CGRect(x: joint.position.x - jointRadius, y: joint.position.y - jointRadius,
                               width: jointRadius * 2, height: jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
    
    // Helper function to convert CIImage to CGImage
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
    // main function to analyze given Image
    func analyzeImage() {
        
        /* Sources:
         https://www.youtube.com/watch?v=6i7RD1laExA
 */
         
         
         
        
        // Problem need an UIImage here, need to be changed!
        //let uiImage : UIImage = UIImage(data: image.pngData())
        guard let img = UIImage(named: "niklas-3"),
            let resizedImage = img.resizeTo(size: modelInputSize) else { //let buffer = resizedImage.toBuffer() else
                return
        }
        
        //http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
        //source: try to conver UIImage into CGimage as input for model
        var ciImage = CIImage(image: resizedImage)
        
        
        
        let cgImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        let poseNetInput = PoseNetInput(image: cgImage!, size: modelInputSize)
        
        // How to set the delegate?
        //poseNet.delegate = self
        
        //self.poseNet.predict(cgImage!)
        
        //poseNet.predict(buffer)
        
        
        /*guard let prediction = try? self.poseNetMLModel.prediction(from: image) else {
            return
        }
        
        let poseNetOutput = PoseNetOutput(prediction: prediction,
                                          modelInputSize: self.modelInputSize,
                                          modelOutputStride: self.outputStride)

        DispatchQueue.main.async {
            self.delegate?.poseNet(self, didPredict: poseNetOutput)
        }
         */
        
        // here
        
        /// Important question: who is the delegate of posenet?
        
        // do the prediction on your own, because we cant use delegation properly
        let prediction = try? self.model.prediction(from: poseNetInput)
        //let output = try? self.model.prediction(image: cgImage!)
        if let prediction = prediction {
            /*
             IDs: does swift start with one?
             0 nose
             ....
             11 left hip
             12 right hip
             13 left knee
             14 right knee
             15 left ankle
             16 right ankle
             */
            print(prediction.multiArrayValue(for: .heatmap)!)
            print(prediction.multiArrayValue(for: .offsets)!)
            print(prediction.multiArrayValue(for: .backwardDisplacementMap)!)
            print(prediction.multiArrayValue(for: .forwardDisplacementMap)!)
            /*
            print("Left Hip")
            print(output.heatmap[11+1]) // Confidence Level
            print(output.displacementBwd[11+1])
            print(output.displacementFwd[11+1])
            print(output.offsets[11+1])
            
            print("Right Hip")
            print(output.heatmap[12+1]) // Confidence Level
            print(output.displacementBwd[12+1])
            print(output.displacementFwd[12+1])
            print(output.offsets[12+1])
            */
            
            
            let poseNetOutput = PoseNetOutput(prediction: prediction,
                                              modelInputSize: self.modelInputSize,
                                              modelOutputStride: self.outputStride)
            
            //PoseNetOutput.
            
            let poseBuilder = PoseBuilder(output: poseNetOutput,
                                          configuration: poseBuilderConfiguration,
                                          inputImage: cgImage!)

            
            print(poseBuilder.pose)
            
            // Overwrite pose
            show(poses: [poseBuilder.pose], on: cgImage!)

            /*let poses = algorithm == .single
                ? [poseBuilder.pose]
                : poseBuilder.poses

            previewImageView.show(poses: poses, on: cgImage)
            */
            }
        
    }
    
    var body: some View {
        NavigationView {
        VStack {
                if isShowingSelectionButton {
                    Button("Use camera") {
                        self.sourceType = 0
                        self.isImagePickerShowing.toggle()
                        self.isShowingSelectionButton.toggle()
                    }.sheet(isPresented: $isImagePickerShowing, onDismiss: {
                        self.isImagePickerShowing = false
                    }) {
                        ImagePicker(
                            isVisible: self.$isImagePickerShowing,
                            image: self.$image,
                            isShowingSelectedImage: self.$isShowingSelectionButton,
                            imagePickerCanceled: self.$imagePickerCanceled,
                            sourceType: self.sourceType)
                    }
                    .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    
                    Spacer()
                        .frame(height: 18)
                    
                    Button(action: {
                        self.sourceType = 1
                        self.isImagePickerShowing.toggle()
                        //self.isShowingSelectionButton.toggle()
                    }, label: {
                        Text("Open gallery")
                    }).sheet(isPresented: $isImagePickerShowing,
                             onDismiss: {
                                self.isImagePickerShowing = false
                            }) {
                        ImagePicker(
                            isVisible: self.$isImagePickerShowing,
                            image: self.$image,
                            isShowingSelectedImage: self.$isShowingSelectionButton,
                            imagePickerCanceled: self.$imagePickerCanceled,
                            sourceType: self.sourceType)
                    }
                    .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        
                        .navigationBarTitle("Choose input", displayMode: .inline)
                        .onAppear {
                            self.isNavigationBarHidden = false
                    }
                } else if !imagePickerCanceled {
                    Text("Your image selection:")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    image? // TODO: avoid force unwrap
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                    NavigationLink(
                        destination: AnalyzedImageView(finalImage: self.finalImage!),
                        // TODO: better solution
                    isActive: $isShowingAnalyzedImageView) {
                        Button("Analyze image") {
                            //
                            self.analyzeImage()
                            //
                            self.isShowingAnalyzedImageView = true
                        }.padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }.navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

// MARK: - Previews
struct ChooseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInputView(isNavigationBarHidden: .constant(false), sourceType: 0)
    }
}
