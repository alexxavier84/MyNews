//
//  MapLoader.swift
//  MyNews
//
//  Created by Apple on 28/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import MapKit

class MapLoader : NSObject {
    
    let locationManager = CLLocationManager()
    
    func load() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
}

extension MapLoader: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) ->Void in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks, placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                // self.countryCode = pm.isoCountryCode ?? ""
                //print(pm.isoCountryCode)
                UserDefaults.standard.set(pm.isoCountryCode, forKey: "countryCode")

            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    
}
