//
//  TopHeadlines.swift
//  MyNews
//
//  Created by Apple on 26/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct TopHeadlines : Codable {
    var sourceId: String?
    var sourceName: String?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: Double?
    var publishedAt: Date?
    
    
    init(_ dictionary: [String: AnyObject]) {
        
        if let sourceDetails = dictionary[NewsClient.JSONResponseKeys.Source] as? [String: AnyObject] {
            sourceId = sourceDetails[NewsClient.JSONResponseKeys.Id] as? String
            sourceName = sourceDetails[NewsClient.JSONResponseKeys.Name] as? String
        }
        
        author = dictionary[NewsClient.JSONResponseKeys.Author] as? String
        title = dictionary[NewsClient.JSONResponseKeys.Title] as? String
        description = dictionary[NewsClient.JSONResponseKeys.Description] as? String
        url = dictionary[NewsClient.JSONResponseKeys.Url] as? String
        urlToImage = dictionary[NewsClient.JSONResponseKeys.UrlToImage] as? Double
        publishedAt = dictionary[NewsClient.JSONResponseKeys.PublishedAt] as? Date
    }
}
