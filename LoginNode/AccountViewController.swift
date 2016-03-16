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
    
    func signupComplete( json_data : NSMutableArray) {
        
    }
    
    func attemptSignup( ) throws {
        print( "attempting sign up")
        let params = [
            "name": nameTextField.text!,
            "email" : emailTextField.text!,
            "user": usernameTextField.text!,
            "pass": passwordTextField.text!
            ] as Dictionary<String,String>
        let url = "https://node-template-knik.c9users.io/signup"
        try api.performRequest(url, method: "PUT", params: params, callback: signupComplete)
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
