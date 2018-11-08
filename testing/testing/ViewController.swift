//
//  ViewController.swift
//  testing
//
//  Created by Brianna Tanusi on 11/8/18.
//  Copyright © 2018 Bri. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    //properties
    var locationManager = CLLocationManager()
    @IBOutlet weak var location_value: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        let urlString = URL(string: "http://devapi.mygasfeed.com/stations/radius/34.06998601990433/-118.4428050624819/5/reg/price/rfej9napna.json?")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            
                            print(jsonResult)
                           // print(jsonResult([1]))
                           // print(jsonResult["geoLocation"])
                        } catch {
                            print("Json Processing Failed")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    


    
    
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion =
            MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10, longitudinalMeters:10)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }

    //actions
    @IBAction func getLocation(_ sender: UIButton) {
        //"start" getting location
        location_value.text="hello"
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
 */

}

