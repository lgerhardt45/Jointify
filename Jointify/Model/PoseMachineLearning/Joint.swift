/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of a structure used to describe a joint.
*/

// MARK: Imports
import CoreGraphics

// MARK: - Joint
class Joint {
    
    // MARK: - Name
    // TODO: Lukas: An enum like this doesn't belong in this class because you also reference to it from other files. Pull it out and call it JointName
    enum Name: Int, CaseIterable {
        case nose
        case leftEye
        case rightEye
        case leftEar
        case rightEar
        case leftShoulder
        case rightShoulder
        case leftElbow
        case rightElbow
        case leftWrist
        case rightWrist
        case leftHip
        case rightHip
        case leftKnee
        case rightKnee
        case leftAnkle
        case rightAnkle
    }
    
    // MARK: Stored Type Properties
    /// The total number of joints available.
    static var numberOfJoints: Int {
        return Name.allCases.count
    }
    
    // MARK: Stored Instance Properties
    /// The name used to identify the joint.
    let name: Name

    /// The position of the joint relative to the image.
    ///
    /// The position is initially relative to the model's input image size and then mapped to the original image
    /// size after constructing the associated pose.
    var position: CGPoint

    /// The joint's respective cell index into model's output grid.
    var cell: PoseNetOutput.Cell

    /// The confidence score associated with this joint.
    ///
    /// The joint confidence is obtained from the `heatmap` array output by the PoseNet model.
    var confidence: Double

    /// A boolean value that indicates if the joint satisfies the joint threshold defined in the configuration.
    var isValid: Bool

    // MARK: Initializers
    init(name: Name,
         cell: PoseNetOutput.Cell = .zero,
         position: CGPoint = .zero,
         confidence: Double = 0,
         isValid: Bool = false) {
        self.name = name
        self.cell = cell
        self.position = position
        self.confidence = confidence
        self.isValid = isValid
    }
    
    // MARK: Private Instance Methods
    // TODO: Lukas: use `CustomStringConvertible` protocol on Name https://stackoverflow.com/a/24707744 and then probably use it like String(Joint.name)
    func nameToString() -> String {
        switch name.rawValue {
        case 0: return("nose")
        case 1: return ("leftEye")
        case 2: return("rightEye")
        case 3: return("leftEar")
        case 4: return("rightEar")
        case 5: return("leftShoulder")
        case 6: return("rightShoulder")
        case 7: return("leftElbow")
        case 8: return("rightElbow")
        case 9: return("leftWrist")
        case 10: return("rightWrist")
        case 11: return("leftHip")
        case 12: return("rightHip")
        case 13: return("leftKnee")
        case 14: return("rightKnee")
        case 15: return("leftAnkle")
        case 16: return("rightAnkle")
        default:
            return("Error: Joint not found.")
        }
    }
}
