//
//  AccountViewController.swift
//  LoginNode
//
//  Created by Nick Scott on 14/03/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        submitButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: helpers
    private func validate(){
        if nameTextField.text?.isEmpty == true ||
            emailTextField.text?.isEmpty == true ||
            usernameTextField.text?.isEmpty == true ||
            passwordTextField.text?.isEmpty == true {
            submitButton.enabled = false
        } else {
            submitButton.enabled = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validate()
        return true
    }
    
    @IBAction func submitClick(sender: UIButton) {
        do {
            try attemptSignup()
        } catch _{
            print( "submit click failed")
        }
    }
    
    func attemptSignup() throws {
        print( "attempting sign up")
        let params = [
            "name": nameTextField.text!,
            "email" : emailTextField.text!,
            "user": usernameTextField.text!,
            "pass": passwordTextField.text!
            ] as Dictionary<String,String>
        let url = NSURL(string: "https://node-template-knik.c9users.io/signup")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        
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
                            print( "signup json data :", json_data)
                            if let jd = json_data![0]["signup"] as? Bool {
                                print( "json return from / :", jd)
                                if jd == true {
                                    success = true
                                }
                            }
                        }
                    } catch let e {
                        print( "json_data threw exception:", e)
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        if success == true {
                            prefs.setValue( self.usernameTextField.text, forKey: "username")
                        } else {
                            // prefs.setNilValueForKey( "username")
                        }
                    }
                })
            }
        }
        task.resume()
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
