//
//  ImageUpdater.swift
//  Spancirfest
//
//  Created by Dino Martan on 04/07/2021.
//

import UIKit
import SDWebImage

enum ImageUpdaterResponse {
    
    case newImageUploaded(url: String)
    case imageUpdated(url: String)
    case imageNotChanged(url: String)
    case error(error: Error?)
    
}

final class ImageUpdater {
    
    //MARK: - Public properties
    
    static let shared = ImageUpdater()
    
    //MARK: - Private properties
    
    //MARK: - Public methods
    
    func updateImage(currentImageView: UIImageView?, oldImageUrl: String?, imagePath: DatabaseImagePathContants, imageQuality: UIImage.ImageQuality, response: @escaping ((ImageUpdaterResponse) -> Void)) {
        if currentImageView?.image == nil && oldImageUrl == nil { response(.error(error: nil)) }
        
        // if old image doesn't exist, only the one in view is set
        if oldImageUrl == nil && currentImageView?.image != nil {
            DatabaseHandler.shared.uploadImage(image: currentImageView!.image!, path: imagePath) { url in
                response(.newImageUploaded(url: url))
            } failure: { error in
                response(.error(error: error))
            }
        }
        
        // if image in view doesn't exist, only the oldUrl is set
        else if currentImageView?.image == nil && oldImageUrl != nil {
            UIImageView().sd_setImage(with: URL(string: oldImageUrl!)) { (image, error, _, _) in
                if image == nil || error != nil { response(.error(error: error)) }
                else { response(.imageNotChanged(url: oldImageUrl!)) }
            }
        }
        
        // if both, image and oldUrl are set, compare them
        else if currentImageView?.image != nil && oldImageUrl != nil {
            UIImageView().sd_setImage(with: URL(string: oldImageUrl!)) { (image, error, _, _) in
                if image == nil || error != nil { response(.error(error: error)) }
                
                // if the images are the same, return no changes
                if image!.isEqualToImage(currentImageView!.image!) { response(.imageNotChanged(url: oldImageUrl!)) }
                // if images are not the same, upload new one
                else {
                    DatabaseHandler.shared.uploadImage(image: currentImageView!.image!, path: imagePath) { url in
                        response(.imageUpdated(url: url))
                    } failure: { error in
                        response(.error(error: error))
                    }
                }
            }
        }
    }
    
}

