//
//  UIImage+Extensions.swift
//  Jointify
//
//  Created by Niklas Bergmüller on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import Foundation
import UIKit

// MARK: UIImage extension
extension UIImage {
    
    /// Scales down width of image to the given height, while maintaining the aspect ratio
    /// returns:
    /// - self scaled down to given height
    func scaleTo(heigth scaleToHeight: CGFloat) -> UIImage? {
        
        let originalImage = self
        
        let originalHeight = originalImage.size.height
        let originalWidth = originalImage.size.width
        
        let scaleRatio = originalHeight / scaleToHeight
        
        let scaleToWidth = originalWidth / scaleRatio
        
        let scaledSize = CGSize(width: scaleToWidth, height: scaleToHeight)
        
        // start drawing environment with size = extended square
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, self.scale)
        
        // draw original image in top left corner
        originalImage.draw(in: CGRect(x: 0, y: 0, width: scaleToWidth, height: scaleToHeight))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // MARK: Stored Instance Methods
    func extendToSquare() -> UIImage? {
        let originalImage = self
        let originalSize = originalImage.size
        let originalWidth = originalSize.width
        let originalHeight = originalSize.height
        
        // set extendedSize to square (width = height)
        let extendedSize = CGSize(width: originalHeight, height: originalHeight)
        
        // start drawing environment with size = extended square
        UIGraphicsBeginImageContextWithOptions(extendedSize, false, self.scale)
        
        // draw original image in top left corner
        originalImage.draw(in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
        
        let squared = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return squared
    }
    
    /// Cuts self to the given width from the left side
    /// Modified from https://stackoverflow.com/a/38777678
    /// returns:
    /// - new UIImage from self with given width
    func cutToWidthFromLeft(_ cutToWidth: CGFloat) -> UIImage? {
        guard let cgimage = self.cgImage else { return self }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        guard let newCgImage = contextImage.cgImage else { return self }
        
        let cutToSize = CGSize(width: cutToWidth,
                               height: newCgImage.size.height)
        
        let rect: CGRect = CGRect(origin: .zero,
                                  size: cutToSize)
        
        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self }
        
        // Create a new image based on the imageRef and rotate back size the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef,
                                       scale: self.scale,
                                       orientation: self.imageOrientation)
        
        UIGraphicsBeginImageContextWithOptions(cutToSize, false, self.scale)
        
        cropped.draw(in: CGRect(origin: .zero,
                                size: cutToSize))
        
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resized ?? self
    }
}
