//
//  PostComments.swift
//  SocialApp
//
//  Created by shafique dassu on 01/07/2023.
//

import Foundation
import Firebase

struct PostComments {
    let postComment: String
    let userId: String
    let commentCreatedAt: Date
    let username: String
    var avatar: URL?
    
    init(postComment: String, userID: String, commentCreatedAt: Date, username: String, avatar: URL? = nil) {
        self.postComment = postComment
        self.userId = userID
        self.commentCreatedAt = commentCreatedAt
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
        guard let postComment = data["commentText"] as? String else {
            print("DEBUG: failed to get username")
            return nil
        }
        guard let commentCreatedAt = data["createdAt"] as? Double else {
            print("DEBUG: failed to get username")
            return nil
        }
        
        self.username = username
        self.postComment = postComment
        self.userId = snapshot.documentID
        self.commentCreatedAt = Date(timeIntervalSince1970: commentCreatedAt)
        
        if let avatar = data["avatar"] as? String,
           let avatarURL = URL(string: avatar) {
            self.avatar = avatarURL
        }
    }
}


