//
//  EncodableExtension.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation

extension Encodable {
    
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
}
