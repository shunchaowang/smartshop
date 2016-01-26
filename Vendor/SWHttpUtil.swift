//
//  SWHttpUtil.swift
//  rheumatic
//
//  Created by Shunchao Wang on 9/18/2015.
//  Copyright © 2015 swang. All rights reserved.
//

import Foundation

typealias CallbackBlock = (result: String?, error: String?) -> ()

enum SWHttpEncodeType {
    case Urlencoded
    case Json
}

class SWHttpUtil: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print("Result: \(resultString)")
        } else {
            print("Error: \(error)")
        }
    }
    
    // http get to return string? result
    func get(url: String, headers: Dictionary<String, String>? = nil, params: Dictionary<String, String>? = nil, stringResponseHandler: (result: String?, error: String?) -> ()) {
        
        // create request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "get"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: .PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
        }
        
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        stringResponseHandler(result: body as String, error: nil)
                    } else {
                        if let unwrappedError = error {
                            stringResponseHandler(result: nil, error: unwrappedError.localizedDescription)
                        }
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }
    
    // http post to return string result
    func post(url: String, headers: Dictionary<String, String>? = nil, params: Dictionary<String, String>? = nil, enctype: SWHttpEncodeType?, stringResponseHandler: (result: String?, error: String?) -> ()) {
        
        // create request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "post"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: .PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
            // set default enctype to be json
        }
        
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        stringResponseHandler(result: body as String, error: nil)
                    } else {
                        if let unwrappedError = error {
                            stringResponseHandler(result: nil, error: unwrappedError.localizedDescription)
                        }
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }
    
    // http get to return json array
    func get(url: String, headers: Dictionary<String, String>?=nil, params: Dictionary<String, String>?=nil, arrayResponseHandler: (results: [NSDictionary]?, error: String?) -> Void) {
       
        // create request

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "get"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: .PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
        }
        
        //var result: [NSDictionary]? = nil
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        // serialize the body into dictionary array
                        do {
                            let arrayResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.MutableContainers) as! Array<NSDictionary>
                            NSLog("arrayResult: %@", arrayResult)
                            arrayResponseHandler(results: arrayResult, error: nil)
                            //result = arrayResult
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    if let unwrappedError = error {
                        arrayResponseHandler(results: nil, error: unwrappedError.localizedDescription)
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }
    
    // http get to return json
    func get(url: String, headers: Dictionary<String, String>?=nil, params: Dictionary<String, String>?=nil, dictionaryResponseHandler: (result: NSDictionary?, error: String?) -> Void) {
        
        // create request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "get"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: .PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
        }
        
        //var result: [NSDictionary]? = nil
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        // serialize the body into dictionary array
                        do {
                            let dictionaryResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            NSLog("dictionaryResult: %@", dictionaryResult!)
                            dictionaryResponseHandler(result: dictionaryResult, error: nil)
                            //result = arrayResult
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    if let unwrappedError = error {
                        dictionaryResponseHandler(result: nil, error: unwrappedError.localizedDescription)
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }
    
    // http post to return array
    // this needs to be added to the header to use json encoding
    // "Content-Type": "application/json;charset=utf-8"
    func post(url: String, headers: Dictionary<String, String>?=nil, params: Dictionary<String, String>?=nil, enctype: SWHttpEncodeType?=nil, arrayResponseHandler: (results: [NSDictionary]?, error: String?) -> Void) {
        
        // create request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "post"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                // set default enctype to be json
                request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: .PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
            // if enctype is set to be urlencoded
            if let unwrappedEnctype = enctype {
                if unwrappedEnctype == SWHttpEncodeType.Urlencoded {
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    var index = 0
                    var postString = ""
                    for(key, value) in unwrappedParams {
                        if index == 0 {
                            postString = "\(key)=\(value)"
                        } else {
                            postString = "\(postString)&\(key)=\(value)"
                        }
                        index++
                    }
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                }
            }
        }
        
        NSLog("Request ==> %@", request)
        
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        // serialize the body into dictionary array
                        do {
                            let arrayResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.MutableContainers) as? Array<NSDictionary>
                            NSLog("arrayResult: %@", arrayResult!)
                            arrayResponseHandler(results: arrayResult, error: nil)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    if let unwrappedError = error {
                        arrayResponseHandler(results: nil, error: unwrappedError.localizedDescription)
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }
    
    // http post to return dictionary
    // this needs to be added to the header to use json encoding
    // "Content-Type": "application/json;charset=utf-8"
    func post(url: String, headers: Dictionary<String, String>?=nil, params: Dictionary<String, String>?=nil, enctype: SWHttpEncodeType?=nil, dictionaryResponseHandler: (result: NSDictionary?, error: String?) -> Void) {
        
        // create request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "post"
        
        // create session configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // create session
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // formulate request header
        if let unwrappedHeaders = headers {
            for (key, value) in unwrappedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // forumualte request params
        if let unwrappedParams = params {
            do {
                // set default enctype to be json
                request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(unwrappedParams, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print(error)
                request.HTTPBody = nil
            }
            // if enctype is set to be urlencoded
            if let unwrappedEnctype = enctype {
                if unwrappedEnctype == SWHttpEncodeType.Urlencoded {
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    var index = 0
                    var postString = ""
                    for(key, value) in unwrappedParams {
                        if index == 0 {
                            postString = "\(key)=\(value)"
                        } else {
                            postString = "\(postString)&\(key)=\(value)"
                        }
                        index++
                    }
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                }
            }
        }
        
        NSLog("Request ==> %@", request)
        
        // create the task
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // data is raw data
            // response should be a http response type
            if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
                NSLog("Data ==> %@", unwrappedData)
                NSLog("Response ==> %@", unwrappedResponse)
                if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
                    if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
                        NSLog("Body ==> %@:", body)
                        // serialize the body into dictionary array
                        do {
                            let dictionaryResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            NSLog("dictionaryResult: %@", dictionaryResult!)
                            dictionaryResponseHandler(result: dictionaryResult, error: nil)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    if let unwrappedError = error {
                        dictionaryResponseHandler(result: nil, error: unwrappedError.localizedDescription)
                    }
                }
            }
        })
        
        // send the request
        task.resume()
    }

    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        
        print("Request: \(request.description)")
        completionHandler(request)
            
    }
    
    
//    private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
//        if let unwrappedData = data, unwrappedResponse = response as? NSHTTPURLResponse {
//            NSLog("Data ==> %@", unwrappedData)
//            NSLog("Response ==> %@", unwrappedResponse)
//            if (unwrappedResponse.statusCode >= 200 && unwrappedResponse.statusCode < 300) {
//                if let body = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) {
//                    NSLog("Body ==> %@:", body)
//                    // serialize the body into dictionary array
//                    do {
//                        let arrayResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.MutableContainers) as! Array<NSDictionary>
//                        NSLog("arrayResult: %@", arrayResult)
//                        arrayHandler(result: arrayResult, error: nil, processed: &result)
//                        //result = arrayResult
//                    } catch {
//                        print(error)
//                    }
//                }
//            } else {
//                if let unwrappedError = error {
//                    arrayHandler(result: nil, error: unwrappedError.localizedDescription, processed: &result)
//                }
//            }
//        }
//
//    }
    
}
