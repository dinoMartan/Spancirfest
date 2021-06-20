//
//  DateExtension.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import Foundation

enum DateStringStyle: String {
    
    case style1 = "HH:mm E, d MMM y"
    
}

extension Date {
    
    func timeToString(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = style
        let string = formatter.string(from: self)
        return string
    }
    
    func toString(style: DateStringStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.rawValue
        let string = formatter.string(from: self)
        return string
    }
    
    
}
