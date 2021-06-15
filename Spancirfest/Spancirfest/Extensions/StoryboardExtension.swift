//
//  StoryboardExtension.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

enum StoryboardId: String {
    
    case Authentication
    
}

extension UIStoryboard {
    
    static func getViewController<T> (viewControllerType: T.Type, from storyboardId: StoryboardId) -> T? {
        let storyboard = UIStoryboard(name: storyboardId.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: String(describing: T.self)) as? T
        return viewController
    }
    
}
