/*
See LICENSE folder for this sample’s licensing information.
Abstract:
Implementation details of a structure used to describe a pose.
*/

// MARK: Imports
import CoreGraphics

// MARK: - Pose
struct Pose {

    // MARK: Stored Type Properties
    /// An array of edges used to define the connections between the joints.
    ///
    /// The index relates to the index used to access the associated value within the displacement maps
    /// output by the PoseNet model.
    static let edges = [
        Edge(from: .nose, towards: .leftEye, index: 0),
        Edge(from: .leftEye, towards: .leftEar, index: 1),
        Edge(from: .nose, towards: .rightEye, index: 2),
        Edge(from: .rightEye, towards: .rightEar, index: 3),
        Edge(from: .nose, towards: .leftShoulder, index: 4),
        Edge(from: .leftShoulder, towards: .leftElbow, index: 5),
        Edge(from: .leftElbow, towards: .leftWrist, index: 6),
        Edge(from: .leftShoulder, towards: .leftHip, index: 7),
        Edge(from: .leftHip, towards: .leftKnee, index: 8),
        Edge(from: .leftKnee, towards: .leftAnkle, index: 9),
        Edge(from: .nose, towards: .rightShoulder, index: 10),
        Edge(from: .rightShoulder, towards: .rightElbow, index: 11),
        Edge(from: .rightElbow, towards: .rightWrist, index: 12),
        Edge(from: .rightShoulder, towards: .rightHip, index: 13),
        Edge(from: .rightHip, towards: .rightKnee, index: 14),
        Edge(from: .rightKnee, towards: .rightAnkle, index: 15)
    ]
    
    // MARK: Stored Instance Properties
    // Needed to accesses the joint with the specified name.
    /// The joints that make up a pose.
    private(set) var joints: [JointName: Joint] = [
        .nose: Joint(name: .nose),
        .leftEye: Joint(name: .leftEye),
        .leftEar: Joint(name: .leftEar),
        .leftShoulder: Joint(name: .leftShoulder),
        .leftElbow: Joint(name: .leftElbow),
        .leftWrist: Joint(name: .leftWrist),
        .leftHip: Joint(name: .leftHip),
        .leftKnee: Joint(name: .leftKnee),
        .leftAnkle: Joint(name: .leftAnkle),
        .rightEye: Joint(name: .rightEye),
        .rightEar: Joint(name: .rightEar),
        .rightShoulder: Joint(name: .rightShoulder),
        .rightElbow: Joint(name: .rightElbow),
        .rightWrist: Joint(name: .rightWrist),
        .rightHip: Joint(name: .rightHip),
        .rightKnee: Joint(name: .rightKnee),
        .rightAnkle: Joint(name: .rightAnkle)
    ]
    
    /// The confidence score associated with this pose.
    var confidence: Double = 0.0
    
    // MARK: Type Methods
    /// Returns all edges that link **from** or **to** the specified joint.
    ///
    /// - parameters:
    ///     - jointName: Query joint name.
    /// - returns: All edges that connect to or from `jointName`.
    static func edges(for jointName: JointName) -> [Edge] {
        return Pose.edges.filter {
            $0.from == jointName || $0.towards == jointName
        }
    }

    /// Returns the edge having the specified parent and child  joint names.
    ///
    /// - parameters:
    ///     - parentJointName: Edge's parent joint name.
    ///     - childJointName: Edge's child joint name.
    /// - returns: All edges that connect to or from `jointName`.
    static func edge(from parentJointName: JointName, to childJointName: JointName) -> Edge? {
        return Pose.edges.first(where: { $0.from == parentJointName && $0.towards == childJointName })
    }
}

// MARK: - Extension: subscript
extension Pose {
    /// Accesses the joint with the specified name.
    subscript(jointName: JointName) -> Joint {
        get {
            assert(joints[jointName] != nil)
            return joints[jointName]!
        }
        set {
            joints[jointName] = newValue
        }
    }
}
