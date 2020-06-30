/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation details of the size property to extend the CGImage class.
*/

// MARK: Imports
import CoreGraphics

// MARK: - CGImage extension
// Needed to get the size of the respective CGImage
extension CGImage {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}
