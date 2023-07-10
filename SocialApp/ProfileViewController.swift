//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 10/05/2023.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = []
    var user: User?
    var userListener: ListenerRegistration?
    var postsListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let profileCellNib = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(profileCellNib, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        observeData()
    }
    
    func observeData() {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        userListener = Firestore.firestore().collection("users").document(userId).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            self.user = User(snapshot: snapshot)
            
            guard self.postsListener == nil else { return }
            self.postsListener = Firestore.firestore().collection("posts").whereField("userId", isEqualTo: userId).addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        self.presentError(title: "Error", message: "Couldnt get posts")
                        return
                    }
                    guard let documents = snapshot?.documents else {
                        self.presentError(title: "Error", message: "Couldnt get posts")
                        return
                    }
                self.posts.removeAll()
                
                    for document in documents {
                        let postId = document.documentID
                        let data = document.data()
                        
                        guard let firebaseImageURL = data["imageURL"] as? String,
                              let imageURL = URL(string: firebaseImageURL) else {
                            continue
                        }
                        guard let userId = data["userId"] as? String else {
                            continue
                        }
                        guard let firebaseCreatedAt = data["createdAt"] as? Double else {
                            continue
                        }
                        guard let description = data["description"] as? String else {
                            continue
                        }
                        let createdAt = Date(timeIntervalSince1970: firebaseCreatedAt)
                        
                        let post = Post(id: postId, userId: userId, imageURL: imageURL, description: description, createdAt: createdAt)
                        
                        self.posts.append(post)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                }
            }
            }
    }
        
    }
extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
            //profile pic
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            cell.delegate = self
            if let user = user {
                cell.nameLabel.text = user.username
                cell.avatarImageView.sd_setImage(with: user.avatar)
            }
            return cell
        }
        
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCollectionViewCell", for: indexPath) as! ProfilePostCollectionViewCell
        cell.configure(post: post)
        
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 270)
        }
        let availableWidth = collectionView.frame.width - (Config.cellGapSize * 2)
        let widthPerItem = availableWidth / CGFloat(Config.itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension ProfileViewController: ProfileCollectionViewCellDelegate {
    func presentImageUploadOptions() {
        let alert = UIAlertController(title: "Upload Profile Image", message: "Choose an Upload Method", preferredStyle: .actionSheet)
        
        let cameraUpload = UIAlertAction(title: "Camera", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true)
            }
            alert.dismiss(animated: true)
        }
        
        let libraryUpload = UIAlertAction(title: "Library", style: .default) { action in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        let deletePhoto = UIAlertAction(title: "Delete", style: .destructive) { action in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraUpload)
        alert.addAction(libraryUpload)
        alert.addAction(deletePhoto)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            picker.dismiss(animated: true)
        let postStoryboard = UIStoryboard(name: "Post", bundle: nil)
            let postVC = postStoryboard.instantiateViewController(withIdentifier: "UploadImageVC") as! UploadImageViewController
            postVC.imageToUpload = editedImage
            postVC.delegate = self
            present(postVC, animated: true)
        }
    }
}

extension ProfileViewController: PostDelegate {
    func imageUploadComplete(downloadURL: String?) {
        guard let downloadURL = downloadURL else {
            presentError(title: "Upload Fail", message: "Image couldnt upload")
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userDetail: [String: Any] = [
             "imageURL": downloadURL,
        ]
        
        Firestore.firestore().collection("users").document(userId).updateData(userDetail)
            }
        }
