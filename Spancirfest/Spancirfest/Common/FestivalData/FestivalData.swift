//
//  FestivalDetails.swift
//  Spancirfest
//
//  Created by Dino Martan on 29/06/2021.
//

import Foundation

final class FestivalData {
    
    //MARK: - Public properties
    
    static let shared = FestivalData()
    
    //MARK: - Public methods
    
    func getFestivalDetails(success: @escaping ((FestivalDetails) -> Void), failure: @escaping ((Error?) -> Void)) {
        DatabaseHandler.shared.getDocumentById(type: FestivalDetails.self, collection: .festivalDetails, documentId: "details") { festivalDetails in
            success(festivalDetails)
        } failure: { error in
            failure(error)
        }
    }
    
}
