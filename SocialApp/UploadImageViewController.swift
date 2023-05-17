//
//  UploadImageViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 16/05/2023.
//

import UIKit
import FirebaseStorage
import Lottie

class UploadImageViewController: UIViewController {

    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    
    var imageToUpload: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.animation = LottieAnimation.named("loadingplane")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
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
