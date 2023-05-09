//
//  HomeViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/04/2023.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

