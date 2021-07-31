//
//  AlerterConstants.swift
//  Spancirfest
//
//  Created by Dino Martan on 13/07/2021.
//

import Foundation

enum AlertTitle: String {
    
    case error = "Error"
    case wrongCode = "Wrong code"
    case oops = "Oops"
    case success = "Success"
    
}

enum AlertMessage: String {

    case somethingWentWrong = "Something went wrong."
    case passwordChanged = "Your password has been changed."
    case wrongCode = "Looks like your code is incorrect. Please try again."
    case checkFields = "Please make sure you input all fields."
    case wrongResponse = "We couldn't get the right response."
    case updateFailed = "Looks like update failed. Please try again."
    case dataFetchingFailed = "Looks like we couldn't fetch data. Please try again."
    
}

enum AlertButton: String {
    
    case ok = "OK"
    
}
