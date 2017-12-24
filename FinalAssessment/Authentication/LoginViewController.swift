//
//  LoginViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.addTarget(self, action: #selector(loginUser) , for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.addTarget(self, action: #selector(signUpUser) , for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func signUpUser() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
            else {return}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.alert(title: "Error", message: validError.localizedDescription)
            }
            
            if user != nil {
                
                NotificationCenter.appLogin()
            }
        }
    }
    
}


