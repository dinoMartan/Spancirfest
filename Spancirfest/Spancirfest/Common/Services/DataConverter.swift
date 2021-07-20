//
//  DataConverter.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation

func getObject<T: Codable, D>(type: T.Type, data: D) -> T? {
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
