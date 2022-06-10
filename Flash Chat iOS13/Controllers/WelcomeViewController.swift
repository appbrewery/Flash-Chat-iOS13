//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colorNum = 0
        var charIndex = 0.0
        let titleText = "⚡️FlashChat"
        //MARK: - simulation of typing && random color of text
        let colorArray = [UIColor.red,UIColor.systemTeal,UIColor.blue,UIColor.purple,UIColor.systemPink,UIColor.gray,UIColor.cyan,UIColor.magenta,UIColor.systemIndigo,UIColor.orange]
        for char in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.15 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(char)
                self.titleLabel.textColor = colorArray.randomElement()
                //MARK: - lastColor
                colorNum += 1
                if colorNum == 10{
                    self.titleLabel.textColor = UIColor(red: 157/255, green: 196/255, blue: 234/255, alpha: 1) //which color will be last
                }else{
                    print("...")
                }
            }
            charIndex += 1
        }
    
    }
    

}
