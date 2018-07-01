//
//  NewsDetailsViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import WebKit
import CoreData

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<FavoriteNewsData>!
    
    var newsContent: NewsContent?
    var isFavorite: Bool! = false
    
    var sv: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    
    fileprivate func setupFetchedResultsController(){
        let fetchRequest: NSFetchRequest<FavoriteNewsData> = FavoriteNewsData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        
        ModalTransitionMediator.instance.setListener(listener: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        
        sv = UIViewController.displaySpinner(onView: self.view)
        
        isFavorite = self.isFavoriteNews(url: (self.newsContent?.url)!)
        if isFavorite {
            self.toggleFavoriteButton.tintColor = nil
        } else {
            self.toggleFavoriteButton.tintColor = .black
        }
        
        let url = NSURL (string: (self.newsContent?.url)!);
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest)
        
        webView.navigationDelegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    @IBAction func onFavoritButtonTouch(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.toggleFavoriteButton.tintColor = nil
        
        if segue.identifier == "showNewsLikeIdentifier"{
            if let newsLikeReasonViewController = segue.destination as? NewsLikeReasonViewController {
                newsLikeReasonViewController.newsContent = self.newsContent
                newsLikeReasonViewController.isFavoriteNews = self.isFavorite
                newsLikeReasonViewController.dataController = self.dataController
                
                newsLikeReasonViewController.delegate = self
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
                self.toggleFavoriteButton.isEnabled = false
                showErrorMessage(error as NSError)
            }
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIViewController.removeSpinner(spinner: sv)
    }
}

extension NewsDetailsViewController : NSFetchedResultsControllerDelegate{
    
}

extension NewsDetailsViewController: ModalTransitionListener{
    
    //required delegate func
    func popoverDismissed() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
        setupFetchedResultsController()
        
        sv = UIViewController.displaySpinner(onView: self.view)
        
        isFavorite = self.isFavoriteNews(url: (self.newsContent?.url)!)
        if isFavorite {
            self.toggleFavoriteButton.tintColor = nil
        } else {
            self.toggleFavoriteButton.tintColor = .black
        }
        
        let url = NSURL (string: (self.newsContent?.url)!);
        let request = NSURLRequest(url: url! as URL);
        webView.load(request as URLRequest)
        
        //webView.navigationDelegate = self
        
    }
}

extension NewsDetailsViewController{
    
    func isFavoriteNews(url: String) -> Bool {
        for favoriteNews in fetchedResultsController.fetchedObjects!{
            if favoriteNews.url == url{
                self.newsContent = NewsContent(favoriteNews)
                return true
            }
        }
        return false
    }
}
