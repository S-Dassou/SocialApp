//
//  PostCollectionViewCell.swift
//  SocialApp
//
//  Created by shafique dassu on 23/05/2023.
//

import UIKit
import SDWebImage

class PostCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    func configure(post: Post) {
        postImageView.sd_setImage(with: post.imageURL)
    }
}
