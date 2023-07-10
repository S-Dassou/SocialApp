//
//  HomeViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/04/2023.
//

import UIKit
import FirebaseAuth
import SDWebImage
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostDetailSegue" {
            let destinationVC = segue.destination as! PostDetailViewController
            let post = sender as! Post
            destinationVC.post = post
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        observePosts()
    }
    
    func observePosts() {
        Firestore.firestore().collection("posts").addSnapshotListener { snapshot, error in
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
    
    func loadData() {
        Firestore.firestore().collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.presentError(title: "Error", message: "Couldnt get posts")
                return
            }
            guard let documents = snapshot?.documents else {
                self.presentError(title: "Error", message: "Couldnt get posts")
                return
            }
            
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


    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let loginVC = authStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = loginVC
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        cell.configure(post: post)
        return cell 
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        performSegue(withIdentifier: "PostDetailSegue", sender: post)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - (Config.cellGapSize * 2)
        let widthPerItem = availableWidth / CGFloat(Config.itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}


