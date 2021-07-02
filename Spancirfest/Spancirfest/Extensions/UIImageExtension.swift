//
//  UIImageExtension.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import UIKit

extension UIImage {
    
    enum ImageQuality: Float {
        
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
        
    }
    
    func getJpeg(quality: ImageQuality) -> UIImage? {
        guard let data = jpegData(compressionQuality: CGFloat(quality.rawValue)) else { return nil }
        let uiImage = UIImage(data: data)
        return uiImage
    }
    
    func isEqualToImage(_ image: UIImage) -> Bool {
            return self.pngData() == image.pngData()
    }
    
}
