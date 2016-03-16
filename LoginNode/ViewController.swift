//
//  ViewController.swift
//  LoginNode
//
//  Created by Nick Scott on 13/03/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.enabled = false
        
        print( "attempting login")
        let url = "https://node-template-knik.c9users.io/"

        do {
            let p = Dictionary<String,String>()
            try api.performRequest(url, method: "GET", params: p, callback: complete)
        } catch let e {
            print( "login attempt failed:", e)
        }
    }
    
    func complete( json_data : NSMutableArray ){
        print( "login complete data : ", json_data)
        if let login = json_data[0]["login"] as? Bool {
            if login == true {
                loginButton.enabled = false
            } else {
                loginButton.enabled = true
            }
        } else {
            loginButton.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutClick(sender: UIButton) {
        do{
            try attemptLogout()
        } catch _{
            print( "attempt logout failed")
        }
    }
    func loggedOut( json_data : NSMutableArray) {
        let jd = json_data[0]["logout"] as! Bool
        if jd == true {
            print( "logged out")
        } else {
            print( "logout failed")
        }
    }

    func attemptLogout() throws {
        print( "attempting login")
        let params = Dictionary<String,String>()
        let url = "https://node-template-knik.c9users.io/logout"
        try api.performRequest( url, method: "POST", params: params, callback: loggedOut)
    }
}

