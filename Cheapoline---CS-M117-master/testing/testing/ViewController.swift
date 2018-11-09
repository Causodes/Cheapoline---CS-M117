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
        
        let urlString = URL(string: "http://devapi.mygasfeed.com/stations/radius/34.06998601990433/-118.7428050624818/5/reg/price/rfej9napna.json?")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: []) as! [String: AnyObject]
                            
                            let all_stations = jsonResult["stations"] as! [Any]
                            
                            //FOR STATION 1
                            let station1 = all_stations[0] as! [String:Any]
                            let station1_name = station1["station"] as! AnyObject
                            let station1_distance = station1["distance"] as! AnyObject
                            let station1_reg_price = station1["reg_price"] as! AnyObject
                            let station1_mid_price = station1["mid_price"] as! AnyObject
                            let station1_pre_price = station1["pre_price"] as! AnyObject
                            let station1_diesel_price = station1["diesel_price"] as! AnyObject
                            
                            //FOR STATION 2
                            let station2 = all_stations[1] as! [String:Any]
                            let station2_name = station2["station"] as AnyObject
                            let station2_distance = station2["distance"] as AnyObject
                            let station2_reg_price = station2["reg_price"] as AnyObject
                            let station2_mid_price = station2["mid_price"] as AnyObject
                            let station2_pre_price = station2["pre_price"] as AnyObject
                            let station2_diesel_price = station2["diesel_price"] as AnyObject
                            
                            //FOR STATION 3
                            let station3 = all_stations[2] as! [String:Any]
                            let station3_name = station3["station"] as AnyObject
                            let station3_distance = station3["distance"] as AnyObject
                            let station3_reg_price = station3["reg_price"] as AnyObject
                            let station3_mid_price = station3["mid_price"] as AnyObject
                            let station3_pre_price = station3["pre_price"] as AnyObject
                            let station3_diesel_price = station3["diesel_price"] as
                            AnyObject
                            
                            print(station1_name)
                            print(station1_distance)
                            print(station1_reg_price)
                            
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

