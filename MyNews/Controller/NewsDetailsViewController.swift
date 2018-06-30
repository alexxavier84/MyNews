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
    
    var sv: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sv = UIViewController.displaySpinner(onView: self.view)
        
        let url = NSURL (string: (self.newsContent?.url)!);
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.navigationDelegate = self
        
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

extension NewsDetailsViewController : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        func showErrorMessage(_ errorMessage: NSError) {
            performUIUpdateOnMain {
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                
                let alert = UIAlertController(title: "", message: errorMessage.localizedDescription, preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if error != nil {
            performUIUpdateOnMain {
                showErrorMessage(error as NSError)
            }
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIViewController.removeSpinner(spinner: sv)
    }
}
