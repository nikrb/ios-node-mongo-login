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
                var success = true
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    do {
                        if let json_data = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers]) as? NSMutableArray {
                            print( "json return from / :", json_data)
                        } else {
                            success = false
                        }
                    } catch {
                        success = false
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


}

