/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The implementation of a structure that analyzes the PoseNet model outputs to detect
 single or multiple poses.
*/

// MARK: Imports
import CoreGraphics

// MARK: - PoseBuilder
struct PoseBuilder {
    
    // MARK: Stored Instance Properties
    /// A prediction from the PoseNet model.
    ///
    /// Prediction outputs are analyzed to find and construct poses.
    let output: PoseNetOutput

    /// A transformation matrix used to map joints from the PoseNet model's input
    ///  image size onto the original image size.
    let modelToInputTransformation: CGAffineTransform

    /// The parameters the Pose Builder uses in its pose algorithms.
    var configuration: PoseBuilderConfiguration

    // MARK: Initializers
    init(output: PoseNetOutput, configuration: PoseBuilderConfiguration, inputImage: CGImage) {
        self.output = output
        self.configuration = configuration

        // Create a transformation matrix to transform joint positions back into the space
        // of the original input size.
        modelToInputTransformation = CGAffineTransform(scaleX: inputImage.size.width / output.modelInputSize.width,
                                                       y: inputImage.size.height / output.modelInputSize.height)
    }
    
    // MARK: Stored Instance Properties
    /// Returns a pose constructed using the outputs from the PoseNet model.
    var pose: Pose {
        var pose = Pose()

        // For each joint, find its most likely position and associated confidence
        // by querying the heatmap array for the cell with the greatest
        // confidence and using this to compute its position.
        pose.joints.values.forEach { joint in
            configure(joint: joint)
        }

        // Compute and assign the confidence for the pose.
        pose.confidence = pose.joints.values
            .map { $0.confidence }.reduce(0, +) / Double(Joint.numberOfJoints)

        // Map the pose joints positions back onto the original image.
        pose.joints.values.forEach { joint in
            joint.position = joint.position.applying(modelToInputTransformation)
        }

        return pose
    }

    // MARK: Private Instance Methods
    /// Sets the joint's properties using the associated cell with the greatest confidence.
    ///
    /// The confidence is obtained from the `heatmap` array output by the PoseNet model.
    /// - parameters:
    ///     - joint: The joint to update.
    private func configure(joint: Joint) {
        // Iterate over the heatmap's associated joint channel to locate the
        // cell with the greatest confidence.
        var bestCell = Cell(0, 0)
        var bestConfidence = 0.0
        for yIndex in 0..<output.height {
            for xIndex in 0..<output.width {
                let currentCell = Cell(yIndex, xIndex)
                let currentConfidence = output.confidence(for: joint.name, at: currentCell)

                // Keep track of the cell with the greatest confidence.
                if currentConfidence > bestConfidence {
                    bestConfidence = currentConfidence
                    bestCell = currentCell
                }
            }
        }

        // Update joint.
        joint.cell = bestCell
        joint.position = output.position(for: joint.name, at: joint.cell)
        joint.confidence = bestConfidence
        joint.isValid = joint.confidence >= configuration.jointConfidenceThreshold
    }
}
