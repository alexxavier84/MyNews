//
//  FavoriteNewsViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteNewsViewController: UIViewController {
    
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<FavoriteNewsData>!
    
    var newsContent: NewsContent?
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.navigationItem.title = "Your Favorite News"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
        
        performUIUpdateOnMain {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.fetchedResultsController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavoriteNewsIdentifier"{
            if let newsDetailsViewController = segue.destination as? NewsDetailsViewController {
                newsDetailsViewController.newsContent = self.newsContent ?? nil
                newsDetailsViewController.dataController = self.dataController
            }
        }
    }
    
}

extension FavoriteNewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteNewsData = self.fetchedResultsController.object(at: indexPath)
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "favoriteNewsReuseIdentifier", for: indexPath)
        tableCell.textLabel?.text = favoriteNewsData.title
        tableCell.detailTextLabel?.text = favoriteNewsData.newsDescription
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.newsContent = NewsContent(self.fetchedResultsController.object(at: indexPath))
        
        performSegue(withIdentifier: "showFavoriteNewsIdentifier", sender: nil)
    }
    
}

extension FavoriteNewsViewController : NSFetchedResultsControllerDelegate{
    
}
