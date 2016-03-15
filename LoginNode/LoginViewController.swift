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
    
   
    func attemptLogin() throws {
        print( "attempting login")
        let params = [ "user": usernameTextField.text!,
                        "pass": passwordTextField.text!,
                        "remember-me" : remember_me
                    ] as Dictionary<String,String>
        let url = NSURL(string: "https://node-template-knik.c9users.io/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        // TODO: don't seem to need this
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject( params, options: [])
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                var success = false
                var json_data : NSMutableArray?
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    do {
                        json_data = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers]) as? NSMutableArray
                        if json_data != nil {
                            success = true
                        }
                    } catch let e {
                        print( "json_data threw exception:", e)
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        if success == true {
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setValue( self.usernameTextField.text, forKey: "username")
                        } else {
                            prefs.setNilValueForKey( "username")
                        }
                    }
                })
            }
        }
        task.resume()
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
    
    @IBAction func forgotPasswordClick(sender: UIButton) {
    }
    
    @IBAction func createAccountClick(sender: UIButton) {
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
