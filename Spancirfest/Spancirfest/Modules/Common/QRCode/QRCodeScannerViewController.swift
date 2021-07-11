//
//  QRCodeScannerViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 11/07/2021.
//

import UIKit
import MercariQRScanner

protocol QRCodeScannerViewControllerDelegate: AnyObject {
    
    func didFailure(error: QRScannerError)
    func didSuccess(code: String)
    
}

class QRCodeScannerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var scannerView: QRScannerView!
    
    //MARK: - Public properties
    
    weak var delegate: QRCodeScannerViewControllerDelegate?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension QRCodeScannerViewController {
    
    private func setupView() {
        configureQRScanner()
    }
    
    private func configureQRScanner() {
        scannerView.configure(delegate: self)
        scannerView.startRunning()
    }
    
}

//MARK: - QRScanner Delegate -

extension QRCodeScannerViewController: QRScannerViewDelegate {
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        delegate?.didFailure(error: error)
        dismiss(animated: true, completion: nil)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        delegate?.didSuccess(code: code)
        dismiss(animated: true, completion: nil)
    }
    
}
