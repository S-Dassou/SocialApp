//
//  PostDetailViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/06/2023.
//

import UIKit
import SDWebImage
import Firebase

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageVIew: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.sd_setImage(with: post.imageURL)
        descriptionLabel.text = post.description
        getUserDetails(userId: post.userId)
        avatarImageVIew.contentMode = .scaleAspectFill
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        Firestore.firestore().collection("posts").document(post.id).collection("likes").document(post.userId).getDocument { snapshot, error in
            if let error  = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else {
                print("snapshot not found")
                return
            }
            if snapshot.exists {
                self.likeButton.isSelected = true
            } else {
                self.likeButton.isSelected = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageVIew.layer.cornerRadius = avatarImageVIew.frame.width / 2
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if likeButton.isSelected {
            likeButton.isSelected = false
            Firestore.firestore().collection("posts").document(post.id).collection("likes").document(post.userId).delete()
        } else {
            likeButton.isSelected = true
            Firestore.firestore().collection("posts").document(post.id).collection("likes").document(post.userId).setData([post.userId: true])
        }
    }
    
    
    func getUserDetails(userId: String) {
        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            guard let user = User(snapshot: snapshot) else { return }
            self.usernameLabel.text = user.username
            self.avatarImageVIew.sd_setImage(with: user.avatar, placeholderImage: UIImage(systemName: "person.fill"))
            
        }
    }

}
