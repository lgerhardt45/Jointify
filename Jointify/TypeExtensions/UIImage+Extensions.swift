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
        print("Scaling image from \(originalWidth) * \(originalHeight) to \(scaleToWidth) * \(scaleToHeight)")
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, self.scale)
        
        // draw original image in top left corner
        originalImage.draw(in: CGRect(x: 0, y: 0, width: scaleToWidth, height: scaleToHeight))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        print("finished scaling image to \(scaleToWidth) * \(scaleToHeight)")
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// resize the image size the correct input size by cropping it size square
    /// from https://stackoverflow.com/a/38777678
    func resizeTo(size: CGSize) -> UIImage? {
         guard let cgimage = self.cgImage else { return self }

           let contextImage: UIImage = UIImage(cgImage: cgimage)

           guard let newCgImage = contextImage.cgImage else { return self }

           let contextSize: CGSize = contextImage.size

           // Set size square
           var posX: CGFloat = 0.0
           var posY: CGFloat = 0.0
           let cropAspect: CGFloat = size.width / size.height

           var cropWidth: CGFloat = size.width
           var cropHeight: CGFloat = size.height

           if size.width > size.height { // Landscape
               cropWidth = contextSize.width
               cropHeight = contextSize.width / cropAspect
               posY = (contextSize.height - cropHeight) / 2
           } else if size.width < size.height { // Portrait
               cropHeight = contextSize.height
               cropWidth = contextSize.height * cropAspect
               posX = (contextSize.width - cropWidth) / 2
           } else { // Square
               if contextSize.width >= contextSize.height { // Square on landscape (or square)
                   cropHeight = contextSize.height
                   cropWidth = contextSize.height * cropAspect
                   posX = (contextSize.width - cropWidth) / 2
               } else { // Square on portrait
                   cropWidth = contextSize.width
                   cropHeight = contextSize.width / cropAspect
                   posY = (contextSize.height - cropHeight) / 2
               }
           }

           let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

           // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

           // Create a new image based on the imageRef and rotate back size the original orientation
           let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

           UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
           cropped.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
           let resized = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return resized ?? self
    }
    
    /// Cuts self to the given width from the left side
    /// returns:
    /// - new UIImage from self with given width
    func cutToWidthFromLeft(_ cutToWidth: CGFloat) -> UIImage? {
        let originalImage = self
        
        let originalHeight = originalImage.size.height
        let originalWidth = originalImage.size.width
        
        let cutToSize = CGSize(width: cutToWidth, height: originalHeight)
        
        // start drawing environment with size = extended square
        print("Cutting image from \(originalWidth) * \(originalWidth) to \(cutToSize.width) * \(cutToSize.height)")
        UIGraphicsBeginImageContextWithOptions(cutToSize, false, self.scale)
        
        // draw original image in top left corner
        originalImage.draw(in: CGRect(x: 0, y: 0, width: cutToSize.width, height: cutToSize.height))
        
        let cutToImage = UIGraphicsGetImageFromCurrentImageContext()
        print("finished scaling image to \(cutToSize.width) * \(cutToSize.height)")
        UIGraphicsEndImageContext()
        
        return cutToImage
        
    }
}
