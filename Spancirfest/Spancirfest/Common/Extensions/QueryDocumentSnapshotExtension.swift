//
//  QueryDocumentSnapshotExtension.swift
//  Spancirfest
//
//  Created by Dino Martan on 16/06/2021.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot {
    
    func getObject<T: Codable>(type: T.Type) -> T? {
        let data = self.data()
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(type, from: json)
            return decoded
        } catch {
            return nil
        }
    }
    
}
