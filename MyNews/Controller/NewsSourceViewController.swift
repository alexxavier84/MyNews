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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "News Channels"
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.delegate = self
        var isoCountryCode = UserDefaults.standard.value(forKey: "countryCode") ?? "us"
        
        NewsClient.sharedInstance().getNewsSources(language: "en", country: isoCountryCode as! String) { (newsSources, error) in
            
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
            
            self.newsSources = newsSources!
            
            performUIUpdateOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*var topNewsViewController = self.tabBarController?.viewControllers![1] as! TopNewsViewController
        topNewsViewController.dataController = self.dataController
        
        var everyNewsViewController = self.tabBarController?.viewControllers![0] as! EveryNewsViewController
        everyNewsViewController.dataController = self.dataController
        
        var favoriteNewsViewController = self.tabBarController?.viewControllers![2] as! FavoriteNewsViewController
        favoriteNewsViewController.dataController = self.dataController*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "showNewsLikeIdentifier"{
            if let newsLikeReasonViewController = segue.destination as? NewsLikeReasonViewController {
                newsLikeReasonViewController.dataController = self.dataController
                
            }
        }*/
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
    
}
