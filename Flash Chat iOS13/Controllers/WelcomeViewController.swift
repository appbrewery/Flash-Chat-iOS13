//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
		let titleText = Constants.appName
		var charIndex = 0
		titleLabel?.text = String()
		for char in titleText {
			let timeInterval = 0.1 * Double(charIndex)
			Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
				self.titleLabel?.text?.append(char)
			}
			charIndex += 1
		}
		if Auth.auth().currentUser != nil {
			performSegue(withIdentifier: Constants.welcomeBackSegue, sender: self)
		}
    }
    

}
