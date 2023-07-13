//
//  CommentTableViewCell.swift
//  SocialApp
//
//  Created by shafique dassu on 12/07/2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var commentAvatarImageView: UIImageView!
    @IBOutlet weak var commentUsernameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
