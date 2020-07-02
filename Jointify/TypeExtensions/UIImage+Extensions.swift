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
}
