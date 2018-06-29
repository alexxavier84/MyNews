//
//  EveryNewsViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class EveryNewsViewController: UIViewController {

    var todaysNews: [NewsContent] = [NewsContent]()
    var newsContent: NewsContent?
    
    var dataController:DataController!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Today's News"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        NewsClient.sharedInstance().getTodaysNews(fromDate: getTodaysDate(), toDate: getTodaysDate()) { (todaysNews, error) in
            UIViewController.removeSpinner(spinner: sv)
            
            func showErrorMessage(_ errorMessage: NSError) {
                performUIUpdateOnMain {
                    let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    }
                    
                    let alert = UIAlertController(title: "", message: errorMessage.localizedDescription, preferredStyle: .alert)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            if let error = error, error != nil {
                performUIUpdateOnMain {
                    showErrorMessage(error)
                }
                return
            }
            
            self.todaysNews = todaysNews!
            
            performUIUpdateOnMain {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEveryNewsIdentifier"{
            if let newsDetailsViewController = segue.destination as? NewsDetailsViewController {
                newsDetailsViewController.newsContent = self.newsContent ?? nil
                newsDetailsViewController.dataController = self.dataController
            }
        }
    }
    
}

extension EveryNewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todaysNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "everyNewsReuseIdentifier", for: indexPath)
        
        tableCell.textLabel?.text = self.todaysNews[indexPath.item].title
        tableCell.detailTextLabel?.text = self.todaysNews[indexPath.item].description
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.newsContent = self.todaysNews[indexPath.item]
        
        performSegue(withIdentifier: "showEveryNewsIdentifier", sender: nil)
    }
    
}

extension EveryNewsViewController{
    
    func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}


