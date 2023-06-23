//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 10/05/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let profileCellNib = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(profileCellNib, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
        
    }
extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCollectionViewCell", for: indexPath)
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 270)
        }
        let availableWidth = collectionView.frame.width - (Config.cellGapSize * 2)
        let widthPerItem = availableWidth / CGFloat(Config.itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

