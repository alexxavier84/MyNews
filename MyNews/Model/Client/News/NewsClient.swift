//
//  NewsClient.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class NewsClient: NSObject {
    
    // shared session
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: NSError) {
                print(error)
                completionHandlerForGET(nil, error)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            guard error == nil else {
                sendError(error! as NSError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let error = error{
                    sendError(error as NSError)
                }
                
                return
            }
            
            guard let data = data else {
                sendError(error! as NSError)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    func taskForDownloadImage(imageUrlParam: String, completionHandlerForDownloadImage: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        
        // create url
        let imageURL = URL(string: imageUrlParam)!
        
        let task = session.dataTask(with: imageURL) { (data, response, error) in
            
            func sendError(_ error: NSError) {
                print(error)
                completionHandlerForDownloadImage(nil, error)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            guard error == nil else {
                sendError(error! as NSError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error! as NSError)
                return
            }
            
            guard let data = data else {
                sendError(error! as NSError)
                return
            }
            
            completionHandlerForDownloadImage(data, nil)
        }
        
        task.resume()
        
    }
    
    
    //MARK : Helpers
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(error)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }
    
    private func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = NewsClient.Constants.ApiScheme
        components.host = NewsClient.Constants.ApiHost
        components.path = NewsClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    class func sharedInstance() -> NewsClient {
        struct Singleton{
            static var sharedInstance = NewsClient()
        }
        return Singleton.sharedInstance
    }
}
