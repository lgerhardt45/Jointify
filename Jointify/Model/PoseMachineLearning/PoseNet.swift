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

// MARK: Imports
import CoreML
import Vision
import SwiftUI

// MARK: - PoseNetDelegate
protocol PoseNetDelegate: AnyObject {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput)
}

// MARK: - PoseNet
class PoseNet {
    
    // MARK: Joint Segment
    /// A data structure used to describe a visual connection between two joints.
    private struct JointSegment {
        let jointA: Joint.Name
        let jointB: Joint.Name
    }

    // // MARK: Constants
    private enum Constants {
        /// The PoseNet model's output stride.
        ///
        /// Valid strides are 16 and 8 and define the resolution of the grid output by the model. Smaller strides
        /// result in higher-resolution grids with an expected increase in accuracy but require more computation.
        /// Larger strides provide a more coarse grid and typically less accurate but are computationally
        /// cheaper in comparison.
        ///
        /// - Note: The output stride is dependent on the chosen model and specified in the metadata.
        /// Other variants of the PoseNet models are available from the Model Gallery.
        static let outputStride = 8
        /// The PoseNet model's input size.
        ///
        /// All PoseNet models available from the Model Gallery support the input sizes 257x257, 353x353, and 513x513.
        /// Larger images typically offer higher accuracy but are more computationally expensive. The ideal size depends
        /// on the context of use and target devices, typically discovered through trial and error.
        static let modelInputSize = CGSize(width: 513, height: 513)
        /// The width of the line connecting two joints.
        static let segmentLineWidth: CGFloat = 5
        /// The color of the line connecting two joints.
        static let segmentColor: UIColor = UIColor.systemTeal
        /// The radius of the circles drawn for each joint.
        static let jointRadius: CGFloat = 10
        /// The color of the circles drawn for each joint.
        static let jointColor: UIColor = UIColor.systemPink
        // Degrees that will be subtraced from the measured angle
        static let neutralNullAngle: Float = 90.0
    }
    
    let side: Side
    private let jointSegments: [JointSegment]
    var degree: Float = 0.0
    
    // MARK: Initializers
    init(side: Side) {
        self.side = side
        
        switch side {
        case .left:
            jointSegments = [
                JointSegment(jointA: .leftHip, jointB: .leftKnee),
                JointSegment(jointA: .leftKnee, jointB: .leftAnkle)
            ]
        case .right:
            jointSegments = [
                JointSegment(jointA: .rightHip, jointB: .rightKnee),
                JointSegment(jointA: .rightKnee, jointB: .rightAnkle)
            ]
        }
    }
    
    // The Core ML model that the PoseNet model uses to generate estimates for the poses.
    /// - Note: Other variants of the PoseNet model are available from the Model Gallery.
    let model = PoseNetMobileNet100S8FP16().model

    /// The set of parameters passed to the pose builder when detecting poses.
    var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    /// Array of poses that is outputted from the model
    var pose: Pose?
    
    // MARK: Instance Methods
    /// Returns an image showing the detected poses.
    ///
    /// - parameters:
    ///     - poses: An array of detected poses.
    ///     - frame: The image used to detect the poses and used as the background for the returned image.
    private func show(pose: Pose, on frame: CGImage) -> UIImage {
        let dstImageSize = CGSize(width: frame.width, height: frame.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()

        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)

        let dstImage = renderer.image { rendererContext in
            // Draw the current frame as the background for the new image.
            drawImage(image: frame, in: rendererContext.cgContext)

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
                
            // TODO: Prevent force unwrapping
            // Draw joints on the correct side only.
            switch side {
            case .left:
                drawJoints(circle: pose.joints[.leftKnee]!, in: rendererContext.cgContext)
                drawJoints(circle: pose.joints[.leftHip]!, in: rendererContext.cgContext)
                drawJoints(circle: pose.joints[.leftAnkle]!, in: rendererContext.cgContext)
            case .right:
                drawJoints(circle: pose.joints[.rightKnee]!, in: rendererContext.cgContext)
                drawJoints(circle: pose.joints[.rightHip]!, in: rendererContext.cgContext)
                drawJoints(circle: pose.joints[.rightAnkle]!, in: rendererContext.cgContext)
            }
                 
        }
        return dstImage
    }
    
    // Calculate the angle between two joints
    // Returns a Float degree number.
    //
    func calcAngleBetweenJoints() -> Float {
        var jointNames: [String]
        var jointPositions = [String: Float]()
        var chosenSide: String
        var innerAngle: Float = 0.0
        
        switch side {
        case .left:
            jointNames = ["leftHip", "leftKnee", "leftAnkle"]
            chosenSide = "left"
        case .right:
            jointNames = ["rightHip", "rightKnee", "rightAnkle"]
            chosenSide = "right"
        }
        
        guard let pose = pose else {
            print("Error. No pose could be detected.")
            return innerAngle
        }
        
        // Get X and Y coordinates of joints and place them in the dictionary
        for joint in pose.joints.values.filter({ $0.isValid }) {
            if jointNames.contains(joint.nameToString()) {
                jointPositions[joint.nameToString() + "X"] = Float(joint.position.x)
                jointPositions[joint.nameToString() + "Y"] = Float(joint.position.y)
            }
        }
        
        /* TODO: Prevent force unwrapping and implement guard statement here
        guard let jointPositions[side + "HipX"] = jointPositions[side + "HipX"],
            jointPositions[side + "HipY"] = jointPositions[side + "HipY"],
            jointPositions[side + "KneeX"] = jointPositions[side + "KneeX"],
            jointPositions[side + "KneeY"] = jointPositions[side + "KneeY"],
            jointPositions[side + "AnkleX"] = jointPositions[side + "AnkleX"],
            jointPositions[side + "AnkleY"] = jointPositions[side + "AnkleY"]
        else {
            print("Error. At least one joint position could not be obtained.")
            return innerAngle
        }*/
        
        // Create vectors leading from ankle and hip towards knee
        let vectorKneeHip: [String: Float] = ["X": jointPositions[chosenSide + "HipX"]! -
                                                   jointPositions[chosenSide + "KneeX"]!,
                                              "Y": jointPositions[chosenSide + "HipY"]! -
                                                   jointPositions[chosenSide + "KneeY"]!]
        let vectorKneeAnkle: [String: Float] = ["X": jointPositions[chosenSide + "AnkleX"]! -
                                                     jointPositions[chosenSide + "KneeX"]!,
                                                "Y": jointPositions[chosenSide + "AnkleY"]! -
                                                     jointPositions[chosenSide + "KneeY"]!]
        // Calculate inner angle of knee
        // TODO: prevent force unqrapping
        let scalarProduct = (vectorKneeHip["X"]! * vectorKneeAnkle["X"]! + vectorKneeHip["Y"]! * vectorKneeAnkle["Y"]!)
        let amountProduct = sqrt(pow(vectorKneeHip["X"]!, 2) + pow(vectorKneeHip["Y"]!, 2)) *
            sqrt(pow(vectorKneeAnkle["X"]!, 2) + pow(vectorKneeAnkle["Y"]!, 2))
        
        // Prevent divided by zero bug
        if amountProduct != 0.0 {
            innerAngle = acos(scalarProduct / amountProduct) * 180 / Float.pi
        } else {
            print("Error. At least one vector is of size 0")
        }
        
        // Subtract neutral null degrees from the measurement
        //innerAngle -= Constants.neutralNullAngle
        return innerAngle
    }

    /// Vertically flips and draws the given image.
    ///
    /// - parameters:
    ///     - image: The image to draw onto the context (vertically flipped).
    ///     - cgContext: The rendering context.
    private func drawImage(image: CGImage, in cgContext: CGContext) {
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
    private func drawLine(from parentJoint: Joint,
                          to childJoint: Joint,
                          in cgContext: CGContext) {
        cgContext.setStrokeColor(Constants.segmentColor.cgColor)
        cgContext.setLineWidth(Constants.segmentLineWidth)

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
        cgContext.setFillColor(Constants.jointColor.cgColor)

        let rectangle = CGRect(x: joint.position.x - Constants.jointRadius, y: joint.position.y - Constants.jointRadius,
                               width: Constants.jointRadius * 2, height: Constants.jointRadius * 2)
        cgContext.addEllipse(in: rectangle)
        cgContext.drawPath(using: .fill)
    }
    
    // Helper function to convert CIImage to CGImage
    private func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, from: inputImage.extent)
    }
    
    // Draw a circle in the location of the given joint.
    // Returns an UIImage with the specified edges and joints drawn on it.
    //
    // - parameters:
    //     - image: The image to be analysed.
    func predict (_ image: UIImage) -> UIImage {
        // Convert UIImage into a CGImage, because this is what the model requires as input
        let resizedImage = image.resizeTo(size: Constants.modelInputSize)
        // TODO: no force unwrapping
        /*guard let resizedImage = resizedImage else {
            print("Error. Image could not be resized.")
            return UIImage(named: "placeholder")!
        }*/
        let ciImage = CIImage(image: resizedImage!)
         // TODO: no force unwrapping
        /*guard let ciImage = ciImage else {
            print("Error. CIImage could not be created.")
            return UIImage(named: "placeholder")!
        }*/
        let cgImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        // Input the converted image into the model and let it run
        let poseNetInput = PoseNetInput(image: cgImage!, size: Constants.modelInputSize)
        let prediction = try? self.model.prediction(from: poseNetInput)
        if let prediction = prediction {
            // Obtain the results of the model and assign them
            let poseNetOutput = PoseNetOutput(prediction: prediction,
                                              modelInputSize: Constants.modelInputSize,
                                              modelOutputStride: Constants.outputStride)
            let poseBuilder = PoseBuilder(output: poseNetOutput,
                                          configuration: poseBuilderConfiguration,
                                          inputImage: cgImage!)
            pose = poseBuilder.pose
            // Calculate the angles between the joints
            degree = calcAngleBetweenJoints()

            guard let pose = pose else {
                print("Error. No pose could be detected.")
                return UIImage(named: "placeholder")!
            }
            
            // Add the joints and edges to the original image
            return show(pose: pose, on: cgImage!)
        } else {
            print("Error. Prediction could not be found.")
            return UIImage(named: "placeholder")!
        }
    }
}
