//
//  User.swift
//  SocialApp
//
//  Created by shafique dassu on 26/06/2023.
//

import Foundation
import Firebase

struct User {
    let id: String
    let username: String
    let avatar: URL?
    
    init(id: String, username: String, avatar: URL? = nil) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else {
            print("DEBUG: failed to get data")
            return nil
        }
        guard let username = data["username"] as? String else {
            print("DEBUG: failed to get username")
            return nil
        }
        self.username = username
        self.id = snapshot.documentID
        if let avatar = data["avatar"] as? String,
           let avatarURL = URL(string: avatar) {
            self.avatar = avatarURL
        }
    }
}


