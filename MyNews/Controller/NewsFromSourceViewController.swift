//
//  SettingsViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class NewsFromSourceViewController: UIViewController {
    
    var newsContents: [NewsContent] = [NewsContent]()
    var newsContent: NewsContent?
    var newsSource: NewsSource?
    
    var dataController:DataController!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        NewsClient.sharedInstance().getNewsFromSource(sourceId: (newsSource?.id)!) { (newsContents, error) in
            
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
                    UIViewController.removeSpinner(spinner: sv)
                    showErrorMessage(error)
                }
                
                return
            }
            
            self.newsContents = newsContents!
            
            performUIUpdateOnMain {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSourceNewsIdentifier"{
            if let newsDetailsViewController = segue.destination as? NewsDetailsViewController {
                newsDetailsViewController.newsContent = self.newsContent ?? nil
                newsDetailsViewController.dataController = self.dataController
            }
        }
    }
    
}

extension NewsFromSourceViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "sourceNewsReuseIdentifier", for: indexPath)
        
        tableCell.textLabel?.text = self.newsContents[indexPath.item].title
        tableCell.detailTextLabel?.text = self.newsContents[indexPath.item].description
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.newsContent = self.newsContents[indexPath.item]
        
        performSegue(withIdentifier: "showSourceNewsIdentifier", sender: nil)
    }
    
}
