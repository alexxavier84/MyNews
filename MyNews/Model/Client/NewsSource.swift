//
//  NewsSource.swift
//  MyNews
//
//  Created by Apple on 26/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct NewsSource : Codable {
    var id: String?
    var name: String?
    var description: String?
    var url: String?
    var category: String?
    var language: String?
    var country: Double?
    
    init(_ dictionary: [String: AnyObject]) {
        id = dictionary[NewsClient.JSONResponseKeys.Id] as? String
        name = dictionary[NewsClient.JSONResponseKeys.Name] as? String
        description = dictionary[NewsClient.JSONResponseKeys.Description] as? String
        url = dictionary[NewsClient.JSONResponseKeys.Url] as? String
        category = dictionary[NewsClient.JSONResponseKeys.Category] as? String
        language = dictionary[NewsClient.JSONResponseKeys.Language] as? String
        country = dictionary[NewsClient.JSONResponseKeys.Country] as? Double
    }
}
