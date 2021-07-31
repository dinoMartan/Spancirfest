//
//  CurrentUser.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import Foundation
import FirebaseAuth

final class CurrentUser {
    
    //MARK: - Public properties
    
    static let shared = CurrentUser()
    
    //MARK: - Private properties
    
    private let auth = Auth.auth()
    
    //MARK: - Public methods
    
    func userSignedIn() -> Bool {
        if auth.currentUser == nil { return false }
        else { return true }
    }
    
    func signOut() -> Bool {
        do {
            try auth.signOut()
            return true
        }
        catch { return false }
    }
    
    func getCurrentUserId() -> String? {
        let id = auth.currentUser?.uid
        return id
    }
    
    func getCurrentUserDetails(result: @escaping (UserDetails?) -> Void) {
        guard let currentUserId = getCurrentUserId() else {
            result(nil)
            return
        }
        DatabaseHandler.shared.getDocumentById(type: UserDetails.self, collection: .userDetails, documentId: currentUserId) { userDetails in
            result(userDetails)
        } failure: { _ in
            result(nil)
        }
    }
    
    //MARK: - Private methods
}
