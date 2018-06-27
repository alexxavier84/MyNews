//
//  NewsConveniance.swift
//  MyNews
//
//  Created by Apple on 25/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

extension NewsClient{
    
    func getNewsSources(language: String, country: String, completionHandlerForNewsSource: @escaping(_ result: [NewsSource]?, _ error: NSError?) -> Void){
        
        let parameters = [
            NewsClient.ParameterKeys.Language : language,
            NewsClient.ParameterKeys.Country : country,
            NewsClient.ParameterKeys.ApiKey : NewsClient.Constants.ApiKey
        ]
        
        self.taskForGETMethod(method: NewsClient.Methods.Sources, parameters: parameters as [String : AnyObject]) { (response, error) in
            
            guard error == nil else{
                completionHandlerForNewsSource(nil, error)
                return
            }
            
            guard let newsSources = response![NewsClient.JSONResponseKeys.Sources] as? [[String: AnyObject]] else {
                completionHandlerForNewsSource(nil, NSError(domain: "getNewsSources", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse News source json"]))
                return
            }
            
            completionHandlerForNewsSource(NewsSource.newsSourceFromResult(newsSources), nil)
        }
    
    }
    
    func getTopHeadlines(country: String, completionHandlerForTopHeadlines: @escaping(_ result: [TopHeadline]?, _ error: NSError?) -> Void){
        
        let parameters = [
            NewsClient.ParameterKeys.Country : country,
            NewsClient.ParameterKeys.ApiKey : NewsClient.Constants.ApiKey
        ]
        
        self.taskForGETMethod(method: NewsClient.Methods.TopHeadlines, parameters: parameters as [String : AnyObject]) { (response, error) in
            
            guard error == nil else{
                completionHandlerForTopHeadlines(nil, error)
                return
            }
            
            guard let topHeadlines = response![NewsClient.JSONResponseKeys.Articles] as? [[String: AnyObject]] else {
                completionHandlerForTopHeadlines(nil, NSError(domain: "getTopHeadlines", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Top headlines json"]))
                return
            }
            
            completionHandlerForTopHeadlines(TopHeadline.topHeadlinesFromResult(topHeadlines), nil)
        }
        
    }
    
    
    
}
