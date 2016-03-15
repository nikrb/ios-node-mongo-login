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
        let url = NSURL(string: "https://node-template-knik.c9users.io/")
        let request = NSURLRequest(URL: url!)
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
                            print( "json data :", json_data)
                            if let jd = json_data![0]["login"] as? Bool {
                                print( "json return from / :", jd)
                                if jd == true {
                                    success = true
                                }
                            }
                        }
                    } catch {
                        print( "login failed")
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        print( "@login success [\(success)]")
                        if success == false {
                            self.loginButton.enabled = true
                        }
                    }
                })
            }
        }
        task.resume()
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

    func attemptLogout() throws {
        print( "attempting login")
        let params = Dictionary<String,String>()
        let url = NSURL(string: "https://node-template-knik.c9users.io/logout")
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
                            print( "manual json data :", json_data)
                            if let jd = json_data![0]["logout"] as? Bool {
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
                        if success == true {
                            print( "logout success")
                        }
                    }
                })
            }
        }
        task.resume()
    }

}

