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
        let jointA: JointName
        let jointB: JointName
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
        static let segmentLineWidth: CGFloat = 2.5
        /// The color of the line connecting two joints.
        static let segmentColor: UIColor = UIColor.systemTeal
        /// The radius of the circles drawn for each joint.
        static let jointRadius: CGFloat = 5
        /// The color of the circles drawn for each joint.
        static let jointColor: UIColor = UIColor.systemPink
        // Degrees that will be subtraced from the measured angle
        static let neutralNullAngle: Float = 90.0
        /// Minimum confidence value that each drawn joint in each frame has to conform to
        ///
        /// E.g. if you analyse the right knee, the joints rightHip, rightKnee & rightAnkle
        /// must have a confidence value above the specified threshold, if this is not fulfilled
        /// the whole image is rejected
        static let confidenceThreshold: Double = 0.3
    }
    
    // MARK: Stored Instance Properties
    public var degree: Float = 0.0
    private let side: Side
    private let jointSegments: [JointSegment]
    private let selectedJointNames: [JointName]
    // mapping the recognized Joints to their respective coordinates on the canvas
    private var jointPositions: [String: Float] = [:]
    // The Core ML model that the PoseNet model uses to generate estimates for the poses.
    /// - Note: Other variants of the PoseNet model are available from the Model Gallery.
    private let model = PoseNetMobileNet100S8FP16().model
    /// The set of parameters passed to the pose builder when detecting poses.
    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    // MARK: Initializers
    init(side: Side) {
        self.side = side
        
        switch side {
        case .left:
            jointSegments = [
                JointSegment(jointA: .leftHip, jointB: .leftKnee),
                JointSegment(jointA: .leftKnee, jointB: .leftAnkle)
            ]
            selectedJointNames = [.leftHip, .leftKnee, .leftAnkle]
        case .right:
            jointSegments = [
                JointSegment(jointA: .rightHip, jointB: .rightKnee),
                JointSegment(jointA: .rightKnee, jointB: .rightAnkle)
            ]
            selectedJointNames = [.rightHip, .rightKnee, .rightAnkle]
        }
    }
    
    // MARK: Instance Methods
    /// Returns an image showing the joints and joint segments.
    func show(frame: CGImage, pose: Pose) -> UIImage {
        
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
                
            guard let leftKneeJoint = pose.joints[.leftKnee],
                let leftHipJoint = pose.joints[.leftHip],
                let leftAnkleJoint = pose.joints[.leftAnkle],
                let rightKneeJoint = pose.joints[.rightKnee],
                let rightHipJoint = pose.joints[.rightHip],
                let rightAnkleJoint = pose.joints[.rightAnkle] else {
                    return
            }
            
            // Draw joints on the correct side only.
            switch side {
            case .left:
                drawJoints(circle: leftKneeJoint, in: rendererContext.cgContext)
                drawJoints(circle: leftHipJoint, in: rendererContext.cgContext)
                drawJoints(circle: leftAnkleJoint, in: rendererContext.cgContext)
            case .right:
                drawJoints(circle: rightKneeJoint, in: rendererContext.cgContext)
                drawJoints(circle: rightHipJoint, in: rendererContext.cgContext)
                drawJoints(circle: rightAnkleJoint, in: rendererContext.cgContext)
            }
                 
        }
        return dstImage
    }
    
    /// Get X and Y coordinates of joints and place them in the dictionary
    /// This function depends on pose, which only is created in the predict() function
    /// Thus, it can only be called once the prediction function is done
    func fillJointCoordinatesDictionaries(_ pose: Pose) {
        for joint in pose.joints.values.filter({ $0.isValid }) {
                jointPositions["\(joint.name)X"] = Float(joint.position.x)
                jointPositions["\(joint.name)Y"] = Float(joint.position.y)
        }
    }
    
    /// Calculate the angle between two joints
    /// Returns a Float degree number.
    func calcAngleBetweenJoints(_ pose: Pose) -> Float {
        var innerAngle: Float = 0.0
        // Place the joint coordinates in the global class dictionary jointPositions
        fillJointCoordinatesDictionaries(pose)
        guard let jointPositionsHipX = jointPositions["\(side)HipX"],
            let jointPositionsHipY = jointPositions["\(side)HipY"],
            let jointPositionsKneeX = jointPositions["\(side)KneeX"],
            let jointPositionsKneeY = jointPositions["\(side)KneeY"],
            let jointPositionsAnkleX = jointPositions["\(side)AnkleX"],
            let jointPositionsAnkleY = jointPositions["\(side)AnkleY"]
        else {
            print("Error. At least one joint position could not be obtained.")
            return innerAngle
        }
        // Create vectors leading from ankle and hip towards knee
        let vectorKneeHip: [String: Float] = ["X": jointPositionsHipX - jointPositionsKneeX,
                                              "Y": jointPositionsHipY - jointPositionsKneeY]
        let vectorKneeAnkle: [String: Float] = ["X": jointPositionsAnkleX - jointPositionsKneeX,
                                                "Y": jointPositionsAnkleY - jointPositionsKneeY]
        // Calculate inner angle of knee
        guard let vectorKneeHipX = vectorKneeHip["X"], let vectorKneeAnkleX = vectorKneeAnkle["X"],
            let vectorKneeHipY = vectorKneeHip["Y"], let vectorKneeAnkleY = vectorKneeAnkle["Y"] else {
                return innerAngle
        }
        let scalarProduct = (vectorKneeHipX * vectorKneeAnkleX + vectorKneeHipY * vectorKneeAnkleY)
        let amountProduct = sqrt(pow(vectorKneeHip["X"]!, 2) + pow(vectorKneeHip["Y"]!, 2)) *
            sqrt(pow(vectorKneeAnkle["X"]!, 2) + pow(vectorKneeAnkle["Y"]!, 2))
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
    private func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, from: inputImage.extent)
    }
    
    /// Runs the given image through the model and saves the output in the respective variables
    ///
    /// - parameters:
    ///     - image: The image to be analysed.
    func predict (_ image: UIImage) -> PoseNetPredictionOutput {
        // Convert UIImage into a CGImage, because this is what the model requires as input
        
        //standard picture
        let defaultImage = UIImage(systemName: "heart.fill")!
        let defaultCIImage = CIImage(image: defaultImage)
        let defaultCGImage = convertCIImageToCGImage(inputImage: defaultCIImage!)!
        
        let errorOutput = PoseNetPredictionOutput(degree: 0,
                                                  image: defaultCGImage,
                                                  outputQualityAcceptable: false,
                                                  pose: Pose(),
                                                  originalFrameSize: defaultCGImage.size)
        
        // scale image down to size expected by model
        guard let scaledImage = image.scaleTo(heigth: Constants.modelInputSize.height) else {
            print("Error. Image could not be scaled.")
            return errorOutput
        }
        // extend image to square
        guard let extendedImage = scaledImage.extendToSquare() else {
            print("Error. Image could not be extended to a square.")
            return errorOutput
        }
        // convert image to CIImage
        guard let ciImage = CIImage(image: extendedImage) else {
            print("Error. CIImage could not be created.")
            return errorOutput
        }
        // convert image to CGImage
        guard let cgImage = convertCIImageToCGImage(inputImage: ciImage) else {
            print("Error. CGImage could not be created.")
            return errorOutput
        }
        
        // Input the converted image into the model and let it run
        let poseNetInput = PoseNetInput(image: cgImage, size: Constants.modelInputSize)
        let prediction = try? self.model.prediction(from: poseNetInput)
        if let prediction = prediction {
            // Obtain the results of the model and assign them
            let poseNetOutput = PoseNetOutput(prediction: prediction,
                                              modelInputSize: Constants.modelInputSize,
                                              modelOutputStride: Constants.outputStride)
            let poseBuilder = PoseBuilder(output: poseNetOutput,
                                          configuration: poseBuilderConfiguration,
                                          inputImage: cgImage)
            let detectedPose = poseBuilder.pose
            // Calculate the angles between the joints
            let angleDegree = calcAngleBetweenJoints(detectedPose)
            // assess the output quality of the model
            let isOutputQualityAcceptable = assessOutputQuality(detectedPose)
            // Create object for the output
            let poseNetPredictionOutput = PoseNetPredictionOutput(degree: angleDegree,
                                                                  image: cgImage,
                                                                  outputQualityAcceptable: isOutputQualityAcceptable,
                                                                  pose: detectedPose,
                                                                  originalFrameSize: scaledImage.size)
            
            return(poseNetPredictionOutput)
        } else {
            print("Error. Prediction could not be found.")
            return errorOutput
        }
    }
    
    // Asses the output quality of the model by checking the confidence values and the X coordinates of the joints
    func assessOutputQuality(_ pose: Pose) -> Bool {
        // Assess confidence value of model
        // Iterate through the confidence values of the joints to find the lowest confidence value
        var lowestConfidence: Double = 1.01
        for (_, joint) in pose.joints {
            if selectedJointNames.contains(joint.name) && joint.confidence < lowestConfidence {
                lowestConfidence = joint.confidence
            }
        }
        // If the lowest confidence value is under the threshold, the model output should not be used
        if lowestConfidence < Constants.confidenceThreshold {
            return false
        }
        // Assess X coordinates of joints
        var otherSide: String
        var rationalCoordinates = true
        
        switch side {
        case .left:
            otherSide = "right"
        case .right:
            otherSide = "left"
        }
        guard let jointPositionsHipXSide = jointPositions["\(side)HipX"],
            let jointPositionsKneeXSide = jointPositions["\(side)KneeX"],
            let jointPositionsAnkleXSide = jointPositions["\(side)AnkleX"],
            let jointPositionsHipXOtherSide = jointPositions[otherSide + "HipX"],
            let jointPositionsKneeXOtherSide = jointPositions[otherSide + "KneeX"],
            let jointPositionsAnkleXOtherSide = jointPositions[otherSide + "AnkleX"],
            let jointPositionsKneeYSide = jointPositions["\(side)KneeY"],
            let jointPositionsAnkleYSide = jointPositions["\(side)AnkleY"]
        else {
            print("Error. At least one joint position could not be obtained.")
            return false
        }
        // Check if X coordinates of right joint are larger than the X coordinates of the left joint and vice versa
        // If this is the case, the model output is irrational
        switch side {
        case .right:
            if jointPositionsHipXSide >= jointPositionsHipXOtherSide ||
                jointPositionsKneeXSide >= jointPositionsKneeXOtherSide ||
                jointPositionsAnkleXSide >= jointPositionsAnkleXOtherSide {
                rationalCoordinates = false
            }
        case .left:
            if jointPositionsHipXSide <= jointPositionsHipXOtherSide ||
                jointPositionsKneeXSide <= jointPositionsKneeXOtherSide ||
                jointPositionsAnkleXSide <= jointPositionsAnkleXOtherSide {
                rationalCoordinates = false
            }
        }
        // Fix "hockeystick problem", where hip and ankle are detected correctly,
        // but the knee is taken from the other leg
        switch side {
        case .right:
            if jointPositionsKneeXSide > jointPositionsAnkleXSide &&
                jointPositionsKneeYSide > jointPositionsAnkleYSide {
               rationalCoordinates = false
            }
        case .left:
            if jointPositionsKneeXSide < jointPositionsAnkleXSide &&
                jointPositionsKneeYSide > jointPositionsAnkleYSide {
                rationalCoordinates = false
            }
        }
        // Fix problem where hip is only detected correctly, but knee and ankle are taken from other leg
        switch side {
        case .right:
            if jointPositionsHipXSide < jointPositionsAnkleXSide && jointPositionsHipXSide < jointPositionsKneeXSide {
                rationalCoordinates = false
            }
        case .left:
            if jointPositionsHipXSide > jointPositionsAnkleXSide && jointPositionsHipXSide > jointPositionsKneeXSide {
                rationalCoordinates = false
            }
        }
        if !rationalCoordinates {
            return false
        } else {
            return true
        }
    }
}
