//
//  LoginViewController.swift
//  LoginNode
//
//  Created by Nick Scott on 14/03/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    private var remember_me = "false"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.enabled = false
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        print( "prefs username [\(prefs.valueForKey("username"))]")
        usernameTextField.text = prefs.valueForKey( "username") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: helpers
    private func validate(){
        if usernameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
            signInButton.enabled = false
        } else {
            signInButton.enabled = true
        }
    }
    
    func loginComplete( json_data : NSMutableArray){
        let jd = json_data[0]["login"] as! Bool
        if jd == true {
            print( "logged in ok")
        } else {
            print( "login failed")
        }
    }
   
    func attemptLogin() throws {
        print( "attempting login")
        let params = [ "user": usernameTextField.text!,
                        "pass": passwordTextField.text!,
                        "remember-me" : remember_me
                    ] as Dictionary<String,String>
        let url = "https://node-template-knik.c9users.io/"
        try api.performRequest( url, method: "POST", params: params, callback: loginComplete)
    }
    
    // MARK: Actions
    @IBAction func signInClick(sender: UIButton) {
        do {
            try attemptLogin()
        } catch _{
            print( "login attempt failed")
        }
    }
    
    @IBAction func rememberMeClick(sender: UIButton) {
        if sender.titleLabel?.text == "\u{2610} Remember Me" {
            sender.setTitle( "\u{2611} Remember Me", forState: .Normal)
            remember_me = "true"
        } else {
            sender.setTitle( "\u{2610} Remember Me", forState: .Normal)
            remember_me = "false"
        }
    }
    
    // MARK: text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validate()
        return true
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
