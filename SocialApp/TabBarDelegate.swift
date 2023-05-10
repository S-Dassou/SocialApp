//
//  TabBarDelegate.swift
//  SocialApp
//
//  Created by shafique dassu on 10/05/2023.
//

import Foundation
import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedViewController = tabBarController.selectedViewController
        guard let _ = selectedViewController else {
            return false
        }
        if selectedViewController == viewController {
            return false
        }
        guard let controllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return false
        }
        if controllerIndex == 1 {
            let postStoryBoard = UIStoryboard(name: "Post", bundle: nil)
            let postVC = postStoryBoard.instantiateViewController(withIdentifier: "PostViewController")
            let navVC = UINavigationController(rootViewController: postVC)
            navVC.modalPresentationStyle = .pageSheet
            selectedViewController?.present(navVC, animated: true)
            return false
        }
        return true
    }
}
