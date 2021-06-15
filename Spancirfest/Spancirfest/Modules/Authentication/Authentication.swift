//
//  Authentication.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit
import FirebaseUI

protocol AuthenticationDelegate: AnyObject {
    
    func signInSuccess(authDataResult: AuthDataResult?)
    func signInFailure(error: Error?)
    
}

final class Auth: NSObject {
    
    //MARK: - Public properties
    
    static let shared = Auth()
    weak var delegate: AuthenticationDelegate?
    
    //MARK: - Private properties
    
    private let authUI = FUIAuth.defaultAuthUI()
    
    //MARK: - Public methods
    
    func getAuthViewController() -> UIViewController? {
        authUI?.delegate = self
        authUI?.providers = getProviders()
        guard let authViewController = authUI?.authViewController() else { return nil }
        return authViewController
    }
    
    //MARK: - Private methods
    
    private func getProviders() -> [FUIAuthProvider] {
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        return providers
    }
    
}

//MARK: - Public extensions -

extension Auth: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil { delegate?.signInSuccess(authDataResult: authDataResult) }
        else { delegate?.signInFailure(error: error) }
    }
    
}
