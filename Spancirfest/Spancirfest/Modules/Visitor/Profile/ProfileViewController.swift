//
//  ProfileViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: - IBActions -

extension ProfileViewController {
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        guard let authenticationViewController = UIStoryboard.getViewController(viewControllerType: AuthenticationViewController.self, from: .Authentication) else { return }
        authenticationViewController.modalPresentationStyle = .fullScreen
        CurrentUser.shared.signOut()
        present(authenticationViewController, animated: true, completion: nil)
    }
    
}
