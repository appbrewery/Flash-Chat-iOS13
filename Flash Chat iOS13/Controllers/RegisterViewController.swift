//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextfield: UITextField!

    @IBOutlet weak var passwordTextfield: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		emailTextfield.delegate = self
		passwordTextfield.delegate = self
		emailTextfield.becomeFirstResponder()
	}
    
    @IBAction func registerPressed(_ sender: Any) {
		if let email = emailTextfield?.text,
		   let password = passwordTextfield?.text {
			Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
				if let error = error {
					// Handle error
					AppDelegate.showError(error, inViewController: self)
				} else {
					// Navigate to ChatViewController
					performSegue(withIdentifier: Constants.registerSegue, sender: self)
				}
			}
		}
    }

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if emailTextfield.isEditing {
			emailTextfield.endEditing(true)
			passwordTextfield.becomeFirstResponder()
		} else if passwordTextfield.isEditing {
			registerPressed(textField)
		}
		return true
	}
    
}
