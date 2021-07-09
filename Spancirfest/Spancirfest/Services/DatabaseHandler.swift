//
//  DatabaseHandler.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation
import Firebase

final class DatabaseHandler {
    
    //MARK: - Public properties

    static let shared = DatabaseHandler()
    
    //MARK: - Private properties

    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    //MARK: - Public non generic methods
    
    func unfollowEvent(eventFollowing: EventFollowing, success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(CollectionsConstants.eventFollowing.rawValue).whereField(DatabaseFieldNameConstants.userId.rawValue, isEqualTo: eventFollowing.userId).whereField(DatabaseFieldNameConstants.eventId.rawValue, isEqualTo: eventFollowing.eventId).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                failure(nil)
                return
            }
            for document in snapshot.documents {
                let documentId = document.documentID
                self.db.collection(CollectionsConstants.eventFollowing.rawValue).document(documentId).delete() { error in
                    if error != nil {
                        failure(error)
                    }
                    else { success() }
                }
            }
        }
    }
    
    func isUserFollowingEvent(userId: String, eventId: String, success: @escaping ((Bool) -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(CollectionsConstants.eventFollowing.rawValue).whereField(DatabaseFieldNameConstants.userId.rawValue, isEqualTo: userId).whereField(DatabaseFieldNameConstants.eventId.rawValue, isEqualTo: eventId).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                failure(nil)
                return
            }
            if error != nil { failure(error) }
            if snapshot.documents.isEmpty { success(false) }
            else { success(true) }
        }
    }
    
    func getFollowingEventsForUser(userId: String, success: @escaping (([Event]) -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(CollectionsConstants.eventFollowing.rawValue).whereField(DatabaseFieldNameConstants.userId.rawValue, isEqualTo: userId).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                failure(nil)
                return
            }
            if error != nil { failure(error) }
            
            var events: [Event] = []
            let documents = snapshot.documents
            let group = DispatchGroup()
            
            for document in documents {
                group.enter()
                guard let eventFollowing = document.getObject(type: EventFollowing.self) else { continue }
                let eventId = eventFollowing.eventId
                self.getDataWhere(type: Event.self, collection: .events, whereField: .eventId, isEqualTo: eventId) { eventsResponse in
                    let event = eventsResponse[0]
                    events.append(event)
                    group.leave()
                } failure: { error in
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                success(events)
            }
        }
    }
    
    func updateLocation(location: Location, completion: @escaping ((Bool) -> Void)) {
        db.collection(CollectionsConstants.locations.rawValue).whereField("locationId", isEqualTo: location.locationId).getDocuments { (queryShapshot, error) in
            if error != nil { completion(false) }
            let document = queryShapshot?.documents[0]
            let documentId = document?.documentID
            if documentId == nil { completion(false) }
            
            self.db.collection(CollectionsConstants.locations.rawValue).document(documentId!).updateData(location.toDictionnary!) { error in
                completion(false)
            }
            
            self.getDataWhere(type: Event.self, collection: .events, whereField: .eventLocationId, isEqualTo: location.locationId) { events in
                
                let group = DispatchGroup()
                
                for event in events {
                    // to do - fix an issue where event is updating twice
                    group.enter()
                    group.enter()
                    var eventSelected = event
                    eventSelected.location = location
                    self.updateEvent(event: eventSelected) { _ in
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(true)
                }
                
            } failure: { _ in
                completion(false)
            }
        }
    }
    
    func updateEventCategory(category: EventCategory, completion: @escaping ((Bool) -> Void)) {
        db.collection(CollectionsConstants.eventCategory.rawValue).whereField("categoryId", isEqualTo: category.categoryId).getDocuments { (queryShapshot, error) in
            if error != nil { completion(false) }
            let document = queryShapshot?.documents[0]
            let documentId = document?.documentID
            if documentId == nil { completion(false) }
            
            self.db.collection(CollectionsConstants.eventCategory.rawValue).document(documentId!).updateData(category.toDictionnary!) { error in
                completion(false)
            }
            
            self.getDataWhere(type: Event.self, collection: .events, whereField: .eventCategoryId, isEqualTo: category.categoryId) { events in
                
                let group = DispatchGroup()
                
                for event in events {
                    // to do - fix an issue where event is updating twice
                    group.enter()
                    group.enter()
                    var eventSelected = event
                    eventSelected.eventCategory = category
                    self.updateEvent(event: eventSelected) { _ in
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(true)
                }
                
            } failure: { _ in
                completion(false)
            }
        }
    }
    
    func updateEvent(event: Event, completion: @escaping ((Bool) -> Void)) {
        db.collection(CollectionsConstants.events.rawValue).whereField("eventId", isEqualTo: event.eventId).getDocuments { (queryShapshot, error) in
            if error != nil { completion(false) }
            let document = queryShapshot?.documents[0]
            let documentId = document?.documentID
            if documentId == nil { completion(false) }
            
            self.db.collection(CollectionsConstants.events.rawValue).document(documentId!).updateData(event.toDictionnary!) { error in
                completion(false)
            }
            completion(true)
        }
    }
    
    func updateEventApproveal(eventApproveal: EventApproveal, completion: @escaping ((Bool) -> Void)) {
        db.collection(CollectionsConstants.eventApproveal.rawValue).whereField("event.eventId", isEqualTo: eventApproveal.event.eventId).getDocuments { (queryShapshot, error) in
            if error != nil { completion(false) }
            let document = queryShapshot?.documents[0]
            let documentId = document?.documentID
            if documentId == nil { completion(false) }
            
            self.db.collection(CollectionsConstants.eventApproveal.rawValue).document(documentId!).updateData(eventApproveal.toDictionnary!) { error in
                completion(false)
            }
            completion(true)
        }
    }
    
    func updateUserDetails(userDetails: UserDetails, userId: String, completion: @escaping ((Bool) -> Void)) {
        db.collection(CollectionsConstants.userDetails.rawValue).document(userId).updateData(userDetails.toDictionnary!) { error in
            completion(false)
        }
        completion(true)
    }
    
    //MARK: - Public generic methods
    
    func getDataWhere<T: Codable>(type: T.Type, collection: CollectionsConstants, whereField: DatabaseFieldNameConstants, isEqualTo: Any, success: @escaping (([T]) -> Void), failure: @escaping ((Error) -> Void)) {
        
        db.collection(collection.rawValue).whereField(whereField.rawValue, isEqualTo: isEqualTo).getDocuments() { (querySnapshot, error) in
            if let error = error { failure(error) }
            else {
                var results: [T] = []
                for document in querySnapshot!.documents {
                    guard let data = document.getObject(type: T.self) else { continue }
                    results.append(data)
                }
                success(results)
            }
        }
    }
    
    func getDataWhereArrayContains<T: Codable>(type: T.Type, collection: CollectionsConstants, whereField: DatabaseFieldNameConstants, contains: Any, success: @escaping (([T]) -> Void), failure: @escaping ((Error) -> Void)) {
        
        db.collection(collection.rawValue).whereField(whereField.rawValue, arrayContains: contains).getDocuments() { (querySnapshot, error) in
            if let error = error { failure(error) }
            else {
                var results: [T] = []
                for document in querySnapshot!.documents {
                    guard let data = document.getObject(type: T.self) else { continue }
                    results.append(data)
                }
                success(results)
            }
        }
    }
    
    func getDocumentById<T: Codable>(type: T.Type, collection: CollectionsConstants, documentId: String, success: @escaping ((T) -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(collection.rawValue).document(documentId).getDocument { (data, error) in
            if error == nil {
                let data = data?.data()
                guard let document = getObject(type: T.self, data: data) else {
                    failure(nil)
                    return
                }
                success(document)
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
    
    func addDocument<T: Codable>(data: T, collection: CollectionsConstants, documentId: String, success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        db.collection(collection.rawValue).document(documentId).setData(data.toDictionnary!) { error in
            if error == nil { failure(error) }
            else { success() }
        }
    }
    
    func uploadImage(image: UIImage, path: DatabaseImagePathContants, success: @escaping ((String) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let file = image.pngData() else {
            failure(nil)
            return
        }
        let name = String.randomString(length: 30)
        let postsRef = storageRef.child("\(path.rawValue)\(name).jpg")
        
        postsRef.putData(file, metadata: nil) { (metadata, error) in
            if metadata == nil { failure(error) }
 
            postsRef.downloadURL { (url, error) in
                if url == nil { failure(error) }
                else { success(url!.absoluteString) }
            }
        }
    }
    
}
