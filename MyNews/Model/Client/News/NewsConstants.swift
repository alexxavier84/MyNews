//
//  NewsConstants.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

extension NewsClient{
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "93c92a9a9df248dabb6aa7948659a754"
        static let Domains = "wsj.com,nytimes.com,ndtv.com"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "newsapi.org"
        static let ApiPath = "/v2/"
        
        // MARK: Const
        static let Json = "json"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: News search
        static let TopHeadlines = "top-headlines"
        static let Sources = "sources"
        static let Everything = "everything"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        //static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "apiKey"
        static let Country = "country"
        static let Category = "category"
        static let Sources = "sources"
        static let Q = "q"
        static let PageSize = "pageSize"
        static let Page = "page"
        static let From = "from"
        static let To = "to"
        static let Language = "language"
        static let SortBy = "sortBy"
        static let Domain = "domains"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: NEWS
        static let Status = "status"
        static let Sources = "sources"
        static let Id = "id"
        static let Name = "name"
        static let Description = "description"
        static let Url = "url"
        static let Category = "category"
        static let Language = "language"
        static let Country = "country"
        static let TotalResults = "totalResults"
        static let Articles = "articles"
        static let Source = "source"
        static let Author = "author"
        static let Title = "title"
        static let UrlToImage = "urlToImage"
        static let PublishedAt = "publishedAt"
    }
}
