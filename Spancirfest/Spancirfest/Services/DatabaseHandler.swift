//
//  DatabaseHandler.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation
import Firebase

final class DatabaseHandler {
    
    //MARK: - Private properties

    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()

    //MARK: - Public properties

    static let shared = DatabaseHandler()
    
    //MARK: - Public methods
    
    func getUserDetails(userId: String, success: @escaping ((UserDetails) -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(CollectionsConstants.userDetails.rawValue).document(userId).getDocument { (data, error) in
            if error == nil {
                let data = data?.data()
                guard let userDetails = getObject(type: UserDetails.self, data: data) else {
                    failure(nil)
                    return
                }
                success(userDetails)
            }
            else { failure(error) }
        }

    }
    
    func getData<T: Codable>(type: T.Type, collection: CollectionsConstants, success: @escaping (([T]) -> Void), failure: @escaping ((Error) -> Void)) {
        var data: [T] = []
        
        db.collection(collection.rawValue).getDocuments() { (querySnapshot, error) in
            if let error = error {
                failure(error)
            } else {
                for document in querySnapshot!.documents {
                    guard let post = document.getObject(type: T.self) else { continue }
                    data.append(post)
                }
                success(data)
            }
        }
    }
    
    func addData<T: Codable>(data: [T], collection: CollectionsConstants, success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        var ref: DocumentReference? = nil
        for element in data {
            guard let dictionary = element.toDictionnary else { continue }
            ref = self.db.collection(collection.rawValue).addDocument(data: dictionary) { error in
                if let error = error {
                    failure(error)
                } else {
                    success()
                }
            }
        }
        failure(nil)
    }
    
    func uploadImage(image: UIImage, success: @escaping ((String) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let file = image.pngData() else {
            failure(nil)
            return
        }
        let name = String.randomString(length: 30)
        let postsRef = storageRef.child("images/\(name).jpg")
        
        postsRef.putData(file, metadata: nil) { (metadata, error) in
            if metadata == nil { failure(error) }
 
            postsRef.downloadURL { (url, error) in
                if url == nil { failure(error) }
                else { success(url!.absoluteString) }
            }
        }
    }
    
}
