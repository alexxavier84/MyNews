//
//  TopHeadlines.swift
//  MyNews
//
//  Created by Apple on 26/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct NewsContent : Codable {
    var sourceId: String?
    var sourceName: String?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Date?
    var newsLikeReason: String?
    
    
    init(_ dictionary: [String: AnyObject]) {
        
        if let sourceDetails = dictionary[NewsClient.JSONResponseKeys.Source] as? [String: AnyObject] {
            sourceId = sourceDetails[NewsClient.JSONResponseKeys.Id] as? String
            sourceName = sourceDetails[NewsClient.JSONResponseKeys.Name] as? String
        }
        
        author = dictionary[NewsClient.JSONResponseKeys.Author] as? String
        title = dictionary[NewsClient.JSONResponseKeys.Title] as? String
        description = dictionary[NewsClient.JSONResponseKeys.Description] as? String
        url = dictionary[NewsClient.JSONResponseKeys.Url] as? String
        urlToImage = dictionary[NewsClient.JSONResponseKeys.UrlToImage] as? String
        publishedAt = dictionary[NewsClient.JSONResponseKeys.PublishedAt] as? Date
        newsLikeReason = ""
    }
    
    init(_ favoriteNewsData: FavoriteNewsData) {
        sourceId = favoriteNewsData.sourceId
        sourceName = favoriteNewsData.sourceName
        author = favoriteNewsData.author
        title = favoriteNewsData.title
        description = favoriteNewsData.newsDescription
        url = favoriteNewsData.url
        urlToImage = favoriteNewsData.urlToImage
        publishedAt = favoriteNewsData.publishedAt
        newsLikeReason = favoriteNewsData.newsLikeReason
    }
    
    static func newsContentFromResult(_ result: [[String: AnyObject]]) -> [NewsContent]{
        
        var newsContent = [NewsContent]()
        
        for topHeadline in result {
            newsContent.append(NewsContent(topHeadline))
        }
        
        return newsContent as [NewsContent]
    }
}
