//
//  AuthenticationViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit
import FirebaseUI

class AuthenticationViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let authUI = FUIAuth.defaultAuthUI()
    private var authViewController: UIViewController?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension AuthenticationViewController {
    
    //MARK: - AuthenticationViewController setup and configuration
    
    private func setupView() {
        configureAuthUI()
        prepareAuthViewController()
        presentAuthViewController()
    }
    
    private func configureAuthUI() {
        authUI?.shouldHideCancelButton = true
    }
    
    //MARK: - AuthViewController setup and configuration
    
    private func prepareAuthViewController() {
        authViewController = getAuthViewController()
    }
    
    private func getAuthViewController() -> UIViewController? {
        authUI?.delegate = self
        authUI?.providers = getProviders()
        guard let authViewController = authUI?.authViewController() else { return nil }
        return authViewController
    }
    
    private func presentAuthViewController() {
        guard authViewController != nil else { return }
        authViewController!.modalPresentationStyle = .fullScreen
        present(authViewController!, animated: false, completion: nil)
    }
    
    private func getProviders() -> [FUIAuthProvider] {
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        return providers
    }
    
}

//MARK: - Delegate extension -

extension AuthenticationViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            // to do - handle error
        }
        else {
            guard let navigationViewController = UIStoryboard.getViewController(viewControllerType: TabBarViewController.self, from: .Navigation),
                  let authDataResult = authDataResult
            else {
                // to do - handle error
                return
            }
            if let additionalUserInfo = authDataResult.additionalUserInfo {
                if additionalUserInfo.isNewUser {
                    addNewUserDetails(userId: authDataResult.user.uid) { completion in
                        guard completion != false else {
                            // to do - handle error
                            return
                        }
                        navigationViewController.modalPresentationStyle = .fullScreen
                        self.authViewController!.present(navigationViewController, animated: true, completion: nil)
                    }
                }
            }
            
            navigationViewController.modalPresentationStyle = .fullScreen
            authViewController!.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    private func addNewUserDetails(userId: String, completion: @escaping ((Bool) -> Void)) {
        let newUserDetails = UserDetails(phoneNumber: nil, isExhibitor: false, isAdmin: false)
        DatabaseHandler.shared.addDocument(data: newUserDetails, collection: .userDetails, documentId: userId) {
            completion(true)
        } failure: { _ in
            completion(false)
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return SignInViewController(authUI: authUI)
    }
    
}

