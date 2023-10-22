//
//  LoginViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/04/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
           presentError(title: "Invalid Details", message: "Please check details")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                let errorDetails = self.checkFirebaseError(error: error)
                self.presentError(title: errorDetails.0, message: errorDetails.1)
                return
            }
            guard let _ = result else {
                self.presentGenericError()
                return
            }
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = Utility.getTabBarController()
        }
    }
    
    private func checkFirebaseError(error: Error) -> (String, String) {
        var errorTitle = ""
        var errorMessage = ""
            if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                switch errorCode {
                case .invalidEmail:
                    errorTitle = "Invalid Email"
                    errorMessage = "Email entered is invalid"
                default:
                    break
                }
            }
        return(errorTitle, errorMessage)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SignUpSegue", sender: nil)
    }
}
