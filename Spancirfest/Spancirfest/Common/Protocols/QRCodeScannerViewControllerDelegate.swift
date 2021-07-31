//
//  QRCodeScannerViewControllerDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation
import MercariQRScanner

protocol QRCodeScannerViewControllerDelegate: AnyObject {
    
    func didFailure(error: QRScannerError)
    func didSuccess(code: String)
    
}
