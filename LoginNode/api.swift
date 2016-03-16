//
//  api.swift
//  LoginNode
//
//  Created by Nick Scott on 16/03/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import Foundation

class api {
    class func performRequest( url:String, method:String, params : Dictionary<String, String>, callback : (( NSMutableArray)->Void)? ) throws {
        print( "@Login.auto")
        
        let turl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: turl!)
        request.HTTPMethod = method
        
        // TODO: don't seem to need this
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if params.count > 0 {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject( params, options: [])
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                var json_data : NSMutableArray?
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    do {
                        json_data = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.MutableContainers]) as? NSMutableArray
                        if json_data != nil {
                            if let jd = json_data![0]["login"] as? Bool {
                                print( "json return from / :", jd)
                            }
                        }
                    } catch let e {
                        print( "json_data threw exception:", e)
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        if callback != nil {
                            callback!( json_data!)
                        }
                    }
                })
            }
        }
        task.resume()
    }
}
