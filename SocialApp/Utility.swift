//
//  Utility.swift
//  SocialApp
//
//  Created by shafique dassu on 01/05/2023.
//

import Foundation
import UIKit

class Utility {
    static func presentError(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        return alert
    }
    func test() {
        return
    }
}
