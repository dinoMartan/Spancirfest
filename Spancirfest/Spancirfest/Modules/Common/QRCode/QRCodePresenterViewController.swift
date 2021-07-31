//
//  QRCodePresenterViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 11/07/2021.
//

import UIKit

class QRCodePresenterViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Public properties
    
    var string: String?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension QRCodePresenterViewController {
    
    private func setupView() {
        configureUI()
    }
    
    private func configureUI() {
        guard let string = string,
              let qrImage = UIImage.generateQRCode(from: string)
        else { return }
        imageView.image = qrImage
    }
    
}
