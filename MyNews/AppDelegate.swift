//
//  AppDelegate.swift
//  MyNews
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let mapLoader = MapLoader()
    
    let dataController = DataController(modelName: "My_News")
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        mapLoader.load()
        dataController.load()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        let everyNewsNavigationController = tabBarController.viewControllers![0] as! UINavigationController
        let everyNewsViewController = everyNewsNavigationController.topViewController as! EveryNewsViewController
        everyNewsViewController.dataController = dataController
        
        var topNewsNavigationController = tabBarController.viewControllers![1] as! UINavigationController
        var topNewsViewController = topNewsNavigationController.topViewController as! TopNewsViewController
        topNewsViewController.dataController = dataController
        
        var favoriteNewsNavigationController = tabBarController.viewControllers![2] as! UINavigationController
        var favoriteNewsViewController = favoriteNewsNavigationController.topViewController as! FavoriteNewsViewController
        favoriteNewsViewController.dataController = dataController
        
        var newsSourceNavigationController = tabBarController.viewControllers![3] as! UINavigationController
        var newsSourceViewController = newsSourceNavigationController.topViewController as! NewsSourceViewController
        newsSourceViewController.dataController = dataController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveViewContext()
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }


}

