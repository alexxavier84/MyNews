//
//  NewsDetailsViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import WebKit

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var dataController:DataController!
    
    var newsContent: NewsContent?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: (self.newsContent?.url)!);
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func onFavoritButtonTouch(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsLikeIdentifier"{
            if let newsLikeReasonViewController = segue.destination as? NewsLikeReasonViewController {
                newsLikeReasonViewController.newsContent = self.newsContent
                newsLikeReasonViewController.dataController = self.dataController
            }
        }
    }
}
