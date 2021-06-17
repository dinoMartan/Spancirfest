//
//  TabBarViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        disableScreensBasedOnUserType()
        setActiveScreen()
    }
    
    private func setActiveScreen() {
        selectedIndex = 1
    }
    
    private func disableScreensBasedOnUserType() {
        guard var viewControllers = viewControllers else { return }
    
        CurrentUser.shared.getCurrentUserDetails { userDetails in
            for controller in viewControllers {
                guard let navigationController = controller as? UINavigationController else { continue }
                let viewController = navigationController.viewControllers[0]
                
                // hide admin screen for everyone who is not admin
                if !(userDetails?.isAdmin ?? false) {
                    if (viewController.isKind(of: AdminDashboardViewController.self)) {
                        let index = viewControllers.firstIndex(of: controller)!
                        viewControllers.remove(at: index)
                    }
                }
                
                // hide exhibitor screen for everyone who is not neither admin nor exhibitor
                if !(userDetails?.isAdmin ?? false) && !(userDetails?.isExhibitor ?? false) {
                    if (viewController.isKind(of: ExhibitorDashboardViewController.self)) {
                        let index = viewControllers.firstIndex(of: controller)!
                        viewControllers.remove(at: index)
                    }
                }
            }
            self.viewControllers = viewControllers
        }
    }

}
