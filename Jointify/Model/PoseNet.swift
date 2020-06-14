/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a facade to interact with the PoseNet model, includes input
 preprocessing and calling the model's prediction function.
*/

/* Sources:
https://www.youtube.com/watch?v=6i7RD1laExA
http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
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
    
    var degree: Float = 0.0
    
    
    // The Core ML model that the PoseNet model uses to generate estimates for the poses.
    /// - Note: Other variants of the PoseNet model are available from the Model Gallery.
    let model = PoseNetMobileNet100S8FP16().model

    /// The set of parameters passed to the pose builder when detecting poses.
    var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    /// Array of poses that is outputted from the model
    var poseArray: [Pose] = []
    
    /// A data structure used to describe a visual connection between two joints.
    struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }

    //let side: String
    
    /// An array of joint-pairs that define the lines of a pose's wireframe drawing.
    /*
    if side == "left" {
        let jointSegments = [JointSegment(jointA: .leftHip, jointB: .leftKnee),
                             JointSegment(jointA: .leftKnee, jointB: .leftAnkle)]
    } else {
        let jointSegments = [JointSegment(jointA: .rightHip, jointB: .rightKnee),
                             JointSegment(jointA: .rightKnee, jointB: .rightAnkle)]
    }
    */
    let jointSegments = [
        // The connected joints that are on the left side of the body.
        //JointSegment(jointA: .leftHip, jointB: .leftShoulder),
        //JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
        //JointSegment(jointA: .leftElbow, jointB: .leftWrist),
        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        // The connected joints that are on the right side of the body.
        //JointSegment(jointA: .rightHip, jointB: .rightShoulder),
        //JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
        //JointSegment(jointA: .rightElbow, jointB: .rightWrist),
        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        JointSegment(jointA: .rightKnee, jointB: .rightAnkle)//,
        // The connected joints that cross over the body.
        //JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
        //JointSegment(jointA: .leftHip, jointB: .rightHip)
    ]

    /// The width of the line connecting two joints.
    var segmentLineWidth: CGFloat = 2
    /// The color of the line connecting two joints.
    var segmentColor: UIColor = UIColor.systemTeal
    /// The radius of the circles drawn for each joint.
    var jointRadius: CGFloat = 4
    /// The color of the circles drawn for each joint.
    var jointColor: UIColor = UIColor.systemPink

    
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
            drawImage(image: frame, in: rendererContext.cgContext)

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
                    
                    // TODO: add confidence statement
                    /// IDs of joints can be found here https://github.com/tensorflow/tfjs-models/tree/master/posenet
                    if joint.name.rawValue > 10 {
                        drawJoints(circle: joint, in: rendererContext.cgContext)
                    }
                }
            }
        }
        
        /// Draw little box with degree number next to knee joint
        /*
        let kneeCoordinateX =
        let kneeCoordinateY =
        
        if side == "left" {
            id -> 13
            pose.joint.position.x
            pose.joint.position.y
        } else {
            id -> 14
        }
 */
        
        
        return dstImage
    }
    
    ///
    func calcAngleBetweenJoints(_ side: String) -> Float {
        var jointNames: [String]
        var jointPositions = [String: Float]()
        
        if side == "left" {
            jointNames = ["leftHip", "leftKnee", "leftAnkle"]
        } else {
            jointNames = ["rightHip", "rightKnee", "rightAnkle"]
        }

        /// TODO: Evaluate if poseArray is even needed
        for pose in poseArray {
            for joint in pose.joints.values.filter({ $0.isValid }) {
                if jointNames.contains(joint.nameToString()) {
                    jointPositions[joint.nameToString() + "X"] = Float(joint.position.x)
                    jointPositions[joint.nameToString() + "Y"] = Float(joint.position.y) // TODO: check if negative values are correct
                }
            }
        }
        
        /// Create vectors leading from ankle and hip towards knee
        let vectorKneeHip: [String: Float] = ["X": jointPositions[side + "HipX"]! - jointPositions[side + "KneeX"]!,
                                              "Y": jointPositions[side + "HipY"]! - jointPositions[side + "KneeY"]!]
        let vectorKneeAnkle: [String: Float] = ["X": jointPositions[side + "AnkleX"]! - jointPositions[side + "KneeX"]!,
                                                "Y": jointPositions[side + "AnkleY"]! - jointPositions[side + "KneeY"]!]
        /// Calculate inner angle of knee
        let scalarProduct = (vectorKneeHip["X"]! * vectorKneeAnkle["X"]! + vectorKneeHip["Y"]! * vectorKneeAnkle["Y"]!)
        let amountProduct = sqrt(pow(vectorKneeHip["X"]!, 2) + pow(vectorKneeHip["Y"]!, 2)) *
            sqrt(pow(vectorKneeAnkle["X"]!, 2) + pow(vectorKneeAnkle["Y"]!, 2))
        
        var innerAngle: Float = 0.0
        
        // Prevent divided by zero bug
        if amountProduct != 0.0 {
            innerAngle = acos(scalarProduct / amountProduct) * 180 / Float.pi
        } else {
            print("Error. At least one vector is of size 0")
        }
        return innerAngle
    }

    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    func drawImage(image: CGImage, in cgContext: CGContext) {
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
    private func drawJoints(circle joint: Joint, in cgContext: CGContext) {
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
            
            poseArray = [poseBuilder.pose]
            
            degree = calcAngleBetweenJoints("left")

            return show(poses: poseArray, on: cgImage!)
        } else {
            // TODO: error message
            print("Error.")
            return UIImage(named: "placeholder")!
        }
    }
}
