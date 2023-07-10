//
//  Post.swift
//  SocialApp
//
//  Created by shafique dassu on 23/05/2023.
//

import Foundation

struct Post {
    let id: String
    let userId: String
    let imageURL: URL
    let description: String
    let createdAt: Date
}

extension Post: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
