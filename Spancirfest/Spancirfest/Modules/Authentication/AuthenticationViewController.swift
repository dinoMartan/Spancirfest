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
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
}

//MARK: - Public extensions -

extension AuthenticationViewController {
    
    func getAuthViewController() -> UIViewController? {
        authUI?.delegate = self
        authUI?.providers = getProviders()
        guard let authViewController = authUI?.authViewController() else { return nil }
        return authViewController
    }
    
}

//MARK: - Private extensions -

//MARK: - ViewController Setup

private extension AuthenticationViewController {
    
    private func setupView() {
        configureAuthUI()
        presentAuthViewController()
    }
    
    private func configureAuthUI() {
        authUI?.shouldHideCancelButton = true
    }
    
    private func presentAuthViewController() {
        guard let authViewController = getAuthViewController() else { return }
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: false, completion: nil)
    }
    
}

//MARK: - Authentication providers

private extension AuthenticationViewController {
    
    private func getProviders() -> [FUIAuthProvider] {
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        return providers
    }
    
}

//MARK: - Delegate extension -

extension AuthenticationViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil { debugPrint("Signed in. Send to the app") }
        else { debugPrint(error?.localizedDescription) }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return SignInViewController(authUI: authUI)
    }
    
}

