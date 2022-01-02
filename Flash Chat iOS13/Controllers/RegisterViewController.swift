//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        // email must be formatted like "name@company.com"
        //password must be atleast 6 characters long, make sure it is "secure text entry" in attributes
        
        if let email = emailTextfield.text, let password = passwordTextfield.text { //if both variables do not fail/aren't nil
            //sign up new users (from Firebase documentation)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription //used in English for user to understand
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self.errorLabel.text = ""
                    }
                } else {
                    //Successful registration -> Navigate to the ChatViewController
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
        
    }
}
