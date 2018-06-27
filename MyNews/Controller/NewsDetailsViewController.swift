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
    
    var newsUrl: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(newsUrl!)
        
        let url = NSURL (string: newsUrl!);
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
