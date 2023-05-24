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
        let imagePath = "images/\(userId)/\(imageName)"
        
        let storageRef = Storage.storage().reference(withPath: imagePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //upload-data
        uploadTask = storageRef.putData(imageData, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
                self.delegate?.imageUploadComplete(downloadURL: nil)
                DispatchQueue.main.sync {
                    self.dismiss(animated: true)
                }
                return
            }
            //download url retrievable after upload complete
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.delegate?.imageUploadComplete(downloadURL: nil)
                    DispatchQueue.main.sync {
                        self.dismiss(animated: true)
                    }
                    return
                }
                self.delegate?.imageUploadComplete(downloadURL: nil)
                DispatchQueue.main.sync {
                    self.dismiss(animated: true)
                }
            }
        }
    
        
        uploadTask!.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount)
            DispatchQueue.main.sync {
                self.progressView.setProgress(Float(percentComplete), animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        uploadTask?.cancel()
        self.delegate?.imageUploadComplete(downloadURL: nil)
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
