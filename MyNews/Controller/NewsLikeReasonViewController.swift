//
//  NewsLikeReasonViewController.swift
//  MyNews
//
//  Created by Apple on 28/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewsLikeReasonViewController: UIViewController {
    
    var newsContent: NewsContent?
    
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<FavoriteNewsData>!
    
    @IBOutlet weak var newsLikeReasonTextView: UITextView!
    @IBOutlet weak var popupView: UIView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
        
        popupView.layer.cornerRadius = 10
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.fetchedResultsController = nil
    }
    
    
    @IBAction func onSubmitTouch(_ sender: Any) {
        
        let favoriteNewsData = FavoriteNewsData(context: self.dataController.viewContext)
        favoriteNewsData.sourceId = self.newsContent?.sourceId ?? ""
        favoriteNewsData.sourceName = self.newsContent?.sourceName ?? ""
        favoriteNewsData.author = self.newsContent?.author ?? ""
        favoriteNewsData.title = self.newsContent?.title ?? ""
        favoriteNewsData.newsDescription = self.newsContent?.description ?? ""
        favoriteNewsData.url = self.newsContent?.url ?? ""
        favoriteNewsData.urlToImage = self.newsContent?.urlToImage ?? ""
        favoriteNewsData.newsLikeReason = newsLikeReasonTextView.text
        favoriteNewsData.publishedAt = self.newsContent?.publishedAt ?? Date()
        
        
        if self.dataController.viewContext.hasChanges{
            do{
                try self.dataController.viewContext.save()
            } catch {
                print(error)
            }
            
        }
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
}

extension NewsLikeReasonViewController : NSFetchedResultsControllerDelegate{
    
    
    
}
