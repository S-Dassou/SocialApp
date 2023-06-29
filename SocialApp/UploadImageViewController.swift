//
//  UploadImageViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 16/05/2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Lottie


class UploadImageViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var imageToUpload: UIImage!
    var uploadTask: StorageUploadTask?
    weak var delegate: PostDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.animation = LottieAnimation.named("loadingplane")
        animationView.loopMode = .loop
        animationView.play()
        
        uploadImage()
    }
    
    func uploadImage() {
        guard let imageData = imageToUpload.jpegData(compressionQuality: 0.75) else {
            dismiss(animated: true)
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        progressView.progress = 0
        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = imageID + ".jpeg"
        //break
        let imagePath = "images/\(userId)/\(imageName)"
        
        let storageRef = Storage.storage().reference(withPath: imagePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //upload-data
        print("DEBUG: preparing to upload image")
        uploadTask = storageRef.putData(imageData, metadata: metaData) { _, error in
        print("DEBUG: upload completed")
            if let error = error {
                print("DEBUG: image upload failed")
                print(error.localizedDescription)
                self.delegate?.imageUploadComplete(downloadURL: nil)
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                return
            }
        print("DEBUG: image upload succeeded")
            //download url retrievable after upload complete
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: image upload failed 2")
                    print(error.localizedDescription)
                    self.delegate?.imageUploadComplete(downloadURL: nil)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                    return
                }
                print("DEBUG: image upload should now post")
                self.delegate?.imageUploadComplete(downloadURL: url?.absoluteString)
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
    
        
        uploadTask!.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount)
            DispatchQueue.main.async {
                self.progressView.setProgress(Float(percentComplete), animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        uploadTask?.cancel()
        self.delegate?.imageUploadComplete(downloadURL: nil)
        dismiss(animated: true)
    }
}
