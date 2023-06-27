//
//  ProfileCollectionViewCell.swift
//  SocialApp
//
//  Created by shafique dassu on 21/06/2023.
//

import UIKit

protocol ProfileCollectionViewCellDelegate: AnyObject {
    func presentImageUploadOptions()
}
class ProfileCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: ProfileCollectionViewCellDelegate?
    
    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.clipsToBounds = true
    }
    
    @IBAction func changeAvatarButtonTapped(_ sender: Any) {
        delegate?.presentImageUploadOptions()
    }
}
