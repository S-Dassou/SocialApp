//
//  HomeViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/04/2023.
//

import UIKit
import FirebaseAuth
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = []
    let cellGapSize: CGFloat = 10
    let itemsPerRow: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - (cellGapSize * 2)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}


