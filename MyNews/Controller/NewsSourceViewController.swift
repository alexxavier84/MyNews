//
//  NewsSourceViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class NewsSourceViewController: UIViewController {
    
    var dataController:DataController!
    
    var newsSources: [NewsSource] = [NewsSource]()
    var newsSource: NewsSource?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "News Sources in Your Country"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var isoCountryCode = UserDefaults.standard.value(forKey: "countryCode") ?? "us"
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        NewsClient.sharedInstance().getNewsSources(language: "en", country: isoCountryCode as! String) { (newsSources, error) in
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
            
            self.newsSources = newsSources!
            
            performUIUpdateOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSourceNewsListingIdentifier"{
            if let newsFromSourceViewController = segue.destination as? NewsFromSourceViewController {
                newsFromSourceViewController.dataController = self.dataController
                newsFromSourceViewController.newsSource = self.newsSource
                
            }
        }
    }
    
}

extension NewsSourceViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsSources.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "newsSourceReuseIdnetifier", for: indexPath)
        tableCell.textLabel?.text = self.newsSources[indexPath.item].name
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.newsSource = self.newsSources[indexPath.item]
        
        performSegue(withIdentifier: "showSourceNewsListingIdentifier", sender: nil)
    }
    
}
