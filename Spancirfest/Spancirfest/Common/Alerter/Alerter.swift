//
//  Alerter.swift
//  Spancirfest
//
//  Created by Dino Martan on 13/07/2021.
//

import UIKit

final class Alerter {
    
    static func showOneButtonAlert(on viewController: UIViewController, title: AlertTitle, message: AlertMessage, actionTitle: AlertButton, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title.rawValue, message: message.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle.rawValue, style: .default, handler: handler)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showOneButtonAlert(on viewController: UIViewController, title: AlertTitle, error: Error?, actionTitle: AlertButton, handler: ((UIAlertAction) -> Void)?) {
        var alert: UIAlertController
        if error != nil {
            alert = UIAlertController(title: title.rawValue, message: error!.localizedDescription, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: title.rawValue, message: AlertMessage.somethingWentWrong.rawValue, preferredStyle: .alert)
        }
        let action = UIAlertAction(title: actionTitle.rawValue, style: .default, handler: handler)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
