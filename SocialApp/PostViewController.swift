//
//  PostViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 10/05/2023.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var removeButtonImage: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                cameraButton.isHidden = true
                previewImageView.image = selectedImage
                removeButtonImage.isHidden = false
            } else {
                cameraButton.isHidden = false
                previewImageView.image = nil
                removeButtonImage.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.contentMode = .scaleAspectFill
        removeButtonImage.isHidden = true
        containerView.backgroundColor = UIColor.lightGray
        containerView.clipsToBounds = true
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 6
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }
            alert.dismiss(animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { action in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func removeImageButtonTapped(_ sender: Any) {
        selectedImage = nil
    }
    
    
}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            selectedImage = image
        }
        picker.dismiss(animated: true)
    }
}
