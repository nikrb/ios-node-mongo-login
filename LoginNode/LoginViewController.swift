//
//  LoginViewController.swift
//  LoginNode
//
//  Created by Nick Scott on 14/03/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func signInClick(sender: UIButton) {
    }
    
    @IBAction func rememberMeClick(sender: UIButton) {
        if sender.titleLabel?.text == "\u{2610} Remember Me" {
            sender.setTitle( "\u{2611} Remember Me", forState: .Normal)
        } else {
            sender.setTitle( "\u{2610} Remember Me", forState: .Normal)
        }
    }
    
    @IBAction func forgotPasswordClick(sender: UIButton) {
    }
    
    @IBAction func createAccountClick(sender: UIButton) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
