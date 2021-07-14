//
//  ExhibitorEventQRScanViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 11/07/2021.
//

import UIKit
import MercariQRScanner

class ExhibitorEventQRScanViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    //MARK: - Public properties
    
    var event: Event?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension ExhibitorEventQRScanViewController {
    
    private func setupView() {
        guard event != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        title = event?.name
    }

}

//MARK: - IBActions -

extension ExhibitorEventQRScanViewController {
    
    @IBAction func didTapScanButton(_ sender: Any) {
        guard let qrScannerViewController = UIStoryboard.getViewController(viewControllerType: QRCodeScannerViewController.self, from: .QRCode) else { return }
        qrScannerViewController.delegate = self
        present(qrScannerViewController, animated: true, completion: nil)
    }
    
}

//MARK: -  QRCodeScannerViewControllerDelegate -

extension ExhibitorEventQRScanViewController: QRCodeScannerViewControllerDelegate {
    
    func didSuccess(code: String) {
        guard let event = event else { return }
        let isPaidUser = event.isPaidUser(idUser: code)
        if isPaidUser {
            view.backgroundColor = .systemGreen
            resultLabel.text = "OK"
        }
        else {
            view.backgroundColor = .systemRed
            resultLabel.text = "Not OK"
        }
    }
    
    func didFailure(error: QRScannerError) {
        Alerter.showOneButtonAlert(on: self, title: .error, message: .somethingWentWrong, actionTitle: .ok, handler: nil)
    }
    
}
