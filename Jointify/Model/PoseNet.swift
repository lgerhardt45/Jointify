/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a facade to interact with the PoseNet model, includes input
 preprocessing and calling the model's prediction function.
*/

import CoreML
import Vision
import SwiftUI

protocol PoseNetDelegate: AnyObject {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput)
}

class PoseNet {
    /// The delegate to receive the PoseNet model's outputs.
    //weak var delegate: PoseNetDelegate?

    /// The PoseNet model's input size.
    ///
    /// All PoseNet models available from the Model Gallery support the input sizes 257x257, 353x353, and 513x513.
    /// Larger images typically offer higher accuracy but are more computationally expensive. The ideal size depends
    /// on the context of use and target devices, typically discovered through trial and error.
    let modelInputSize = CGSize(width: 513, height: 513)

    /// The PoseNet model's output stride.
    ///
    /// Valid strides are 16 and 8 and define the resolution of the grid output by the model. Smaller strides
    /// result in higher-resolution grids with an expected increase in accuracy but require more computation. Larger
    /// strides provide a more coarse grid and typically less accurate but are computationally cheaper in comparison.
    ///
    /// - Note: The output stride is dependent on the chosen model and specified in the metadata. Other variants of the
    /// PoseNet models are available from the Model Gallery.
    let outputStride = 8
    
    let model = PoseNetMobileNet100S8FP16().model
    
    //var algorithm: Algorithm = .multiple

    /// The set of parameters passed to the pose builder when detecting poses.
    var poseBuilderConfiguration = PoseBuilderConfiguration()
    
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

    /// The Core ML model that the PoseNet model uses to generate estimates for the poses.
    ///
    /// - Note: Other variants of the PoseNet model are available from the Model Gallery.
    //private let poseNetMLModel = PoseNetMobileNet075S16FP16().model

    /// Calls the `prediction` method of the PoseNet model and returns the outputs to the assigned
    /// `delegate`.
    ///
    /// - parameters:
    ///     - image: Image passed by the PoseNet model.
    /*func predict(_ image: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Wrap the image in an instance of PoseNetInput to have it resized
            // before being passed to the PoseNet model.
            let input = PoseNetInput(image: image, size: self.modelInputSize)

            guard let prediction = try? self.poseNetMLModel.prediction(from: input) else {
                return
            }

            let poseNetOutput = PoseNetOutput(prediction: prediction,
                                              modelInputSize: self.modelInputSize,
                                              modelOutputStride: self.outputStride)

            DispatchQueue.main.async {
                self.delegate?.poseNet(self, didPredict: poseNetOutput)
            }
        }
    }*/
    
    /// Returns an image showing the detected poses.
    ///
    /// - parameters:
    ///     - poses: An array of detected poses.
    ///     - frame: The image used to detect the poses and used as the background for the returned image.
    func show(poses: [Pose], on frame: CGImage) -> UIImage {
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

        return dstImage
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
    
    func predict (_ image: UIImage) -> UIImage {
        let resizedImage = image.resizeTo(size: modelInputSize)
        
        //guard let resizedImage = resizedImage else {
        //    return
        //}
        
        var ciImage = CIImage(image: resizedImage!) // TODO: no force unwrapping
        
        let cgImage = convertCIImageToCGImage(inputImage: ciImage!) // TODO: no force unwrapping
        let poseNetInput = PoseNetInput(image: cgImage!, size: modelInputSize)
            
        let prediction = try? self.model.prediction(from: poseNetInput)
        if let prediction = prediction {
            let poseNetOutput = PoseNetOutput(prediction: prediction,
                                              modelInputSize: self.modelInputSize,
                                              modelOutputStride: self.outputStride)
            
            let poseBuilder = PoseBuilder(output: poseNetOutput,
                                          configuration: poseBuilderConfiguration,
                                          inputImage: cgImage!)

            return show(poses: [poseBuilder.pose], on: cgImage!)
        } else {
            // TODO: error message
            print("Error.")
            return UIImage(named: "placeholder")!
        }
    }
}
