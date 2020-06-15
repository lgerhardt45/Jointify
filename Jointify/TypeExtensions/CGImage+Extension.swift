/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of the size property to extend the CGImage class.
*/

// MARK: Imports
import CoreGraphics

// MARK: - CGImage extension
// TODO: consider file name: what does this extension do?
extension CGImage {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}
