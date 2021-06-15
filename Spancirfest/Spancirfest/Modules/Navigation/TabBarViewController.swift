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
        for controller in viewControllers {
            
            guard let navigationController = controller as? UINavigationController else { continue }
            let viewController = navigationController.viewControllers[0]
            
            if (viewController.isKind(of: AdminDashboardViewController.self)) {
                let index = viewControllers.firstIndex(of: controller)!
                // viewControllers.remove(at: index)
            }
            
            if (viewController.isKind(of: ExhibitorDashboardViewController.self)) {
                let index = viewControllers.firstIndex(of: controller)!
                // viewControllers.remove(at: index)
            }
        }
        self.viewControllers = viewControllers
    }

}
