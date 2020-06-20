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
    // resize the image to the correct input size
    func resizeTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
