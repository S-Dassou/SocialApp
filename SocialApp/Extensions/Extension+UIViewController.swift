//
//  Extension+UIViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 01/05/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentError(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        return alert
    }
    func presentGenericError() {
        let alert = UIAlertController(title: "Oops", message: "Ya Messed Up", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
