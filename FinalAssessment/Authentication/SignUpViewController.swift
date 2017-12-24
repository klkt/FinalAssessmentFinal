//
//  SignUpViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    
    @IBOutlet weak var signUpBtn: UIButton! {
    didSet {
            signUpBtn.addTarget(self, action: #selector(signUpUser) , for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func signUpUser() {
        
        let ref = Database.database().reference()
        
        guard let id = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
            else {return}
        
        if password == "" || confirmPassword == "" {
            alert(title: "Invalid Input", message: "Password field can't be empty")
        }else if password != confirmPassword {
            alert(title: "Passwords do not match", message: "Password fields must match")
        }else if password.count < 6 || confirmPassword.count < 6 {
            alert(title: "Password too short", message: "Password must contain at least 6 characters")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: confirmPassword) { (user, error) in
            if let validError = error {
                self.alert(title: "Error", message: validError.localizedDescription)
            }
            
            guard let validUser = user
                else {
                    print("No valid user")
                    return
            }
            
            let uid = validUser.uid
            
            let user : [String: Any] = ["email": email, "id": id]
            
            ref.child("users").child(uid).setValue(user)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
