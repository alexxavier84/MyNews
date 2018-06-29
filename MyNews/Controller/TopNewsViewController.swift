//
//  ViewController.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MapKit

class TopNewsViewController: UIViewController {

    var topHeadlines: [NewsContent] = [NewsContent]()
    var newsContent: NewsContent?
    var countryCode: String?
    
    var dataController:DataController!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarItem.title = "Top News"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        var isoCountryCode = UserDefaults.standard.value(forKey: "countryCode") ?? "us"
        
        NewsClient.sharedInstance().getTopHeadlines(country: isoCountryCode as! String) { (topHeadlines, error) in
            
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
            
            self.topHeadlines = topHeadlines!
            
            performUIUpdateOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        /*
        var everyNewsController = self.tabBarController?.viewControllers![0] as! EveryNewsViewController
        everyNewsController.dataController = self.dataController
        
        var favoriteNewsController = self.tabBarController?.viewControllers![2] as! FavoriteNewsViewController
        favoriteNewsController.dataController = self.dataController
        
        var newsSourceViewController = self.tabBarController?.viewControllers![3] as! NewsSourceViewController
        newsSourceViewController.dataController = self.dataController*/
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTopNewsIdentifier"{
            if let newsDetailsViewController = segue.destination as? NewsDetailsViewController {
                newsDetailsViewController.newsContent = self.newsContent ?? nil
                newsDetailsViewController.dataController = self.dataController
                
            }
        }
    }

}

extension TopNewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topHeadlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "topNewsReuseIdentifier", for: indexPath)
        
        tableCell.textLabel?.text = self.topHeadlines[indexPath.item].title
        tableCell.detailTextLabel?.text = self.topHeadlines[indexPath.item].description
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.newsContent = self.topHeadlines[indexPath.item]
        
        performSegue(withIdentifier: "showTopNewsIdentifier", sender: nil)
    }
}

