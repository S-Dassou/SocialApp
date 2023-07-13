//
//  CommentDetailViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 29/06/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class CommentDetailViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentDetailTableView: UITableView!
    
    
    var post: Post!
    var comments: [PostComments] = [] 
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.isScrollEnabled = false
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 0.5
        
        observeComments()
        getUser()
        commentDetailTableView.delegate = self
        commentDetailTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commentTextView.layer.cornerRadius = 5
    }
    
    func getUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                return
            }
//            guard let userData = snapshot.data() else {
//                return
//            }
//            guard let username = userData["username"] as? String else {
//                return
//            }
//            var avatarURL: URL?
//            
//            if let avatar = userData["avatarURL"] as? String
//              {
//               avatarURL = URL(string: avatar)
//            }
//            let user = User(id: userId, username: username, avatar: avatarURL)
            self.user = User(snapshot: snapshot)
        }
    }
    
    func observeComments() {
        Firestore.firestore().collection("posts").document(post.id).collection("comments").addSnapshotListener { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.presentError(title: "Error", message: "Couldnt get posts")
                return
            }
            print("snapshot succeeded")
            guard let documents = snapshot?.documents else {
                self.presentError(title: "Error", message: "Couldnt get posts")
                return
            }
            
            self.comments.removeAll()
            
                for document in documents {
                    print("loop entered")
                    let commentId = document.documentID
                    let data = document.data()
                    
                    guard let firebaseCreatedAt = data["createdAt"] as? Double else {
                        print("no created at")
                        continue
                    }
                    guard let userId = data["userId"] as? String else {
                        print("no userId 1")
                        continue
                    }
                    guard let postComment = data["postComment"] as? String else {
                        print("no postComment")
                        continue
                    }
                    guard let username = data["username"] as? String else {
                        print("no username")
                        continue
                    }
                    
                    let createdAt = Date(timeIntervalSince1970: firebaseCreatedAt)
                    
                    let comment = PostComments(postComment: postComment, userID: userId, commentCreatedAt: createdAt, username: username)
                    
                    self.comments.append(comment)
            }
            print(self.comments)
            DispatchQueue.main.async {
                self.commentDetailTableView.reloadData()
            }
        }
    }

    @IBAction func commentPostButtonTapped(_ sender: Any) {
        print("comment button tapped")
        
        guard let postComment = commentTextView.text,
        postComment.count > 0
        else {
            return
        }
        guard let username = user?.username else {
            print("no username")
            return }
        
        guard let userId = user?.id else {
            print("no userId")
            return
        }
        
        var commentDetail: [String: Any] = [
            "postComment": postComment,
            "createdAt": Date().timeIntervalSince1970,
            "username": username,
            "userId": userId
        ]
        
        if let avatar = user?.avatar?.absoluteString {
            commentDetail["avatar"] = avatar
             }
        
        Firestore.firestore().collection("posts").document(post.id).collection("comments").document().setData(commentDetail)
    }
}

extension CommentDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        
        cell.commentAvatarImageView.sd_setImage(with: comment.avatar, placeholderImage: UIImage(systemName: "person.fill"))
        
        cell.commentUsernameLabel.text = comment.username
        cell.commentTextLabel.text = comment.postComment
        
        return cell 
    }


}

extension CommentDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}



extension CommentDetailViewController: UITextViewDelegate {
    func commentTextViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.text == "" {
            commentTextView.text = "what's on your mind?"
            commentTextView.textColor = UIColor.lightGray
        }
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 0.5
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
}






//Phase 1: Writing data correctly to firebase
// get user model by making query to firebase Q4G - we already have the user model in console. Why not use a delegate and pass data from 1 VC to another?
// did this line 36 in profile VC
// user model takes in this object and ensures info is there

// get username and avatar from user model - using var

//

// set data to include comment username and avatar in FS

// SWRefinement - where does username and avatar come from?

// today: create user object (part way)
 
//Phase 2: Retrieve data to display comments
