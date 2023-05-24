//
//  PostViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 10/05/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol PostDelegate: AnyObject {
    func imageUploadComplete(downloadURL: String?)
}

class PostViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var removeButtonImage: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    
    let maxCharacterCount = 80
    var charactersRemaining = 80
    
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                print("image is showing")
                cameraButton.isHidden = true
                previewImageView.image = selectedImage
                removeButtonImage.isHidden = false
            } else {
                print("image failed")
                cameraButton.isHidden = false
                previewImageView.image = nil
                removeButtonImage.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UploadImageSegue" {
            let destinationVC = segue.destination as! UploadImageViewController
            let selectedImage = sender as! UIImage
            destinationVC.imageToUpload = selectedImage
            destinationVC.delegate = self
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
        
        descriptionTextView.text = "What's on your mind"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(endEditingTextView))
        view.addGestureRecognizer(viewTap)
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 6
    }
    
   @objc func endEditingTextView() {
        view.endEditing(true)
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
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        //validation
        guard let selectedImage = selectedImage else {
            presentError(title: "No Image", message: "Add an Image to Post")
            return
        }
        guard let postText = descriptionTextView.text,
              postText.count > 0 && descriptionTextView.textColor != UIColor.lightGray else {
            return
        }
        performSegue(withIdentifier: "UploadImageSegue", sender: selectedImage)
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
//MARK: - text view delegate
extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.textColor = UIColor.black
            descriptionTextView.text = ""
        }
        descriptionTextView.layer.borderColor = UIColor.systemTeal.cgColor
        descriptionTextView.layer.borderWidth = 2
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            descriptionTextView.text = "what's on your mind?"
            descriptionTextView.textColor = UIColor.lightGray
        }
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = descriptionTextView.text.count
        charactersRemaining = maxCharacterCount - characterCount
        characterCountLabel.text = "\(charactersRemaining)"
        if charactersRemaining <= 15 {
            characterCountLabel.textColor = UIColor.red
        } else {
            characterCountLabel.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if charactersRemaining <= 0 {
            if range.length > 0 {
                return true
            } else {
                return false
            }
        }
        return true
    }
}

extension PostViewController: PostDelegate {
    func imageUploadComplete(downloadURL: String?) {
        guard let downloadURL = downloadURL else {
            presentError(title: "Upload Fail", message: "Image couldnt upload")
            return
        }
        
        let postText = descriptionTextView.text!
        
        let postDetail: [String: Any] = [
            "description": postText,
            "imageURL": downloadURL,
            "createdAt": Date().timeIntervalSince1970
        ]
        
        Firestore.firestore().collection("posts").document().setData(postDetail) { error in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
     
}
