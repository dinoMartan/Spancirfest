//
//  EventCategoryViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 05/07/2021.
//

import UIKit
import SDWebImage

class EventCategoryViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var categoryNameTextField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Public properties
    
    var eventCategory: EventCategory?
    
    //MARK: - Private properties
    
    private let imagePickerController = UIImagePickerController()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension EventCategoryViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        backgroundView.layer.cornerRadius = 15
        if eventCategory != nil { loadData() }
    }
    
    private func loadData() {
        guard let eventCategory = eventCategory else { return }
        categoryNameTextField.text = eventCategory.description
        if let image = eventCategory.image {
            imageView.sd_setImage(with: URL(string: image), completed: nil)
        }
    }
    
}

//MARK: - IBActions -

extension EventCategoryViewController {
    
    @IBAction func didTapOutside(_ sender: Any) {
        categoryNameTextField.resignFirstResponder()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        // add new category
        if eventCategory == nil {
            let eventCategoryId = String.randomString(length: 10)
            prepareEventCategory(categoryId: eventCategoryId) { eventCategory in
                DatabaseHandler.shared.addData(data: [eventCategory], collection: .eventCategory) {
                    self.dismiss(animated: true, completion: nil)
                } failure: { error in
                    // to do - handle error
                    self.dismiss(animated: true, completion: nil)
                }

            } failure: { error in
                // to do - handle error
                self.dismiss(animated: true, completion: nil)
            }
        }
        // update category
        else {
            prepareEventCategory(categoryId: eventCategory!.categoryId) { eventCategory in
                DatabaseHandler.shared.updateEventCategory(category: eventCategory) { didComplete in
                    if !didComplete {
                        // to do - handle error
                    }
                }
                self.dismiss(animated: true, completion: nil)
            } failure: { error in
                // to do - handle error
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func prepareEventCategory(categoryId: String, success: @escaping ((EventCategory) -> Void), failure: @escaping ((Error?) -> Void)) {
        ImageUpdater.shared.updateImage(currentImageView: imageView, oldImageUrl: eventCategory?.image, imagePath: .categoryImage, imageQuality: .medium) { response in
            guard let name = self.categoryNameTextField.text else {
                failure(nil)
                return
            }
            var eventCategory = EventCategory(categoryId: categoryId, description: name, image: nil)
            switch response {
            case .noImage:
                eventCategory.image = nil
            case .newImageUploaded(let url):
                eventCategory.image = url
            case .imageUpdated(let url):
                eventCategory.image = url
            case .imageNotChanged(let url):
                eventCategory.image = url
            case .error(let error):
                failure(error)
            }
            success(eventCategory)
        }
    }
    
    @IBAction func didTapSetImageButton(_ sender: Any) {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

//MARK: - ImagePicker Delegate -

extension EventCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { imageView.image = pickedImage }
        dismiss(animated: true, completion: nil)
    }
    
}
