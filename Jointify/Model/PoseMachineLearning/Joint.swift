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
    // TODO: Lukas: An enum like this doesn't belong in this class because you also reference to it from other files.
    //Pull it out and call it JointName
    enum Name: Int, CaseIterable, CustomStringConvertible {
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
        
        var description: String {
            switch self {
            case .nose: return "nose"
            case .leftEye: return "leftEye"
            case .rightEye: return "rightEye"
            case .leftEar: return "leftEar"
            case .rightEar: return "rightEar"
            case .leftShoulder: return "leftShoulder"
            case .rightShoulder: return "rightShoulder"
            case .leftElbow: return "leftElbow"
            case .rightElbow: return "rightElbow"
            case .leftWrist: return "leftWrist"
            case .rightWrist: return "rightWrist"
            case .leftHip: return "leftHip"
            case .rightHip: return "rightHip"
            case .leftKnee: return "leftKnee"
            case .rightKnee: return "rightKnee"
            case .leftAnkle: return "leftAnkle"
            case .rightAnkle: return "rightAnkle"
            }
        }
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
    var cell: Cell

    /// The confidence score associated with this joint.
    ///
    /// The joint confidence is obtained from the `heatmap` array output by the PoseNet model.
    var confidence: Double

    /// A boolean value that indicates if the joint satisfies the joint threshold defined in the configuration.
    var isValid: Bool

    // MARK: Initializers
    init(name: Name,
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
