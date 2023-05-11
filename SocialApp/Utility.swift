//
//  Utility.swift
//  SocialApp
//
//  Created by shafique dassu on 01/05/2023.
//

import Foundation
import UIKit

class Utility {
    static func getTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier:"HomeViewController")
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        
        let postStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let postVC = postStoryboard.instantiateViewController(withIdentifier: "PostViewController")
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        homeNavVC.tabBarItem.image = UIImage(systemName: "house")
        homeNavVC.tabBarItem.title = "Home"
        
        postVC.tabBarItem.image = UIImage(systemName: "paperplane")
        postVC.tabBarItem.title = "Post"
        
        profileNavVC.tabBarItem.image = UIImage(systemName: "person")
        profileNavVC.tabBarItem.title = "Profile"
        
        tabBarController.viewControllers = [homeNavVC, postVC, profileNavVC]
        
        tabBarController.delegate = tabBarDelegate
        return tabBarController
    }
    }

