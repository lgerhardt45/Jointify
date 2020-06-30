/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a structure used to describe a joint.
*/

// MARK: Imports
import CoreGraphics

// MARK: - Joint
class Joint {
    
    // MARK: Stored Type Properties
    /// The total number of joints available.
    static var numberOfJoints: Int {
        return JointName.allCases.count
    }
    
    // MARK: Stored Instance Properties
    /// The name used to identify the joint.
    let name: JointName

    /// The position of the joint relative to the image.
    ///
    /// The position is initially relative to the model's input image size and then mapped to the original image
    /// size after constructing the associated pose.
    var position: CGPoint

    /// The joint's respective cell index into model's output grid.
    var cell: Cell

    /// The confidence score associated with this joint.
    ///
    /// The joint confidence is obtained from the `heatmap` array output by the PoseNet model.
    var confidence: Double

    /// A boolean value that indicates if the joint satisfies the joint threshold defined in the configuration.
    var isValid: Bool

    // MARK: Initializers
    init(name: JointName,
         cell: Cell = .zero,
         position: CGPoint = .zero,
         confidence: Double = 0,
         isValid: Bool = false) {
        self.name = name
        self.cell = cell
        self.position = position
        self.confidence = confidence
        self.isValid = isValid
    }
}
