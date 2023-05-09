//
//  SignUpViewController.swift
//  SocialApp
//
//  Created by shafique dassu on 26/04/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //validation
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {
           presentError(title: "Invalid Details", message: "Please check details")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                let errorDetails = self.checkFirebaseError(error: error)
                self.presentError(title: errorDetails.0, message: errorDetails.1)
                return
            }
            guard let result = result else {
                self.presentGenericError()
                return
            }
            let uid = result.user.uid
            Firestore.firestore().collection("users").document(uid).setData([
                "username": username,
                "email": email
            ])
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = homeVC
        }
    }
    private func checkFirebaseError(error: Error) -> (String, String) {
        var errorTitle = ""
        var errorMessage = ""
            if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                switch errorCode {
                case .emailAlreadyInUse:
                    errorTitle = "Signup Error"
                    errorMessage = "The email provided is already taken"
                case .invalidEmail:
                    errorTitle = "Invalid Email"
                    errorMessage = "Email entered is invalid"
                case .weakPassword:
                    errorTitle = "Sign Up Error"
                    errorMessage = "Add strength to the password"
                default:
                    break
                }
            }
        return(errorTitle, errorMessage)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
}


