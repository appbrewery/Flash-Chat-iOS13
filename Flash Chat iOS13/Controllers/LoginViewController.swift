//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text { //if both variables do not fail/aren't nil
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription //used in English for user to understand
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self.errorLabel.text = ""
                    }
                    
                } else {
                    //Navigate to ChatViewController
                    self.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
            }
        }
    }
    
}
