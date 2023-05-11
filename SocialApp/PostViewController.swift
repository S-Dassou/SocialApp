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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { action in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    

}
