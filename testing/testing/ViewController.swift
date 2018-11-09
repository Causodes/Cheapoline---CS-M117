//
//  ViewController.swift
//  testing
//
//  Created by Brianna Tanusi on 11/8/18.
//  Copyright © 2018 Bri. All rights reserved.
//  FROM GITHUB

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    //properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var foundLocation = false;
    @IBOutlet weak var location_value: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    
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
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location
            
            
            var buildURLString = "http://devapi.mygasfeed.com/stations/radius/"
            buildURLString += "\(currentLocation.coordinate.latitude)"
            buildURLString += "/" + "\(currentLocation.coordinate.longitude)"
            buildURLString += "/5/reg/price/rfej9napna.json?"
            location_value.text = buildURLString
            
            let urlString = URL(string: buildURLString)
            
            if let url = urlString {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error)
                    } else {
                        if let urlContent = data {
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: []) as! [String: AnyObject]
                                
                                let all_stations = jsonResult["stations"] as! [Any]
                                let num_of_stations = all_stations.count
                                
                                //IF THERE ARE NO STATIONS : NEED TO IMPLEMENT ERROR CHECKING
                                if(num_of_stations <= 0){
                                    print("no stations, please try again")
                                }
                                
                                //NEED TO IMPLEMENT FOR WHEN N/A OCCURS
                                
                                //FOR STATION 1
                                let station1 = all_stations[0] as! [String:Any]
                                let station1_name = station1["station"] as AnyObject
                                let station1_distance = station1["distance"] as AnyObject
                                let station1_reg_price = station1["reg_price"] as AnyObject
                                let station1_mid_price = station1["mid_price"] as AnyObject
                                let station1_pre_price = station1["pre_price"] as AnyObject
                                let station1_diesel_price = station1["diesel_price"] as AnyObject
                                
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
                                
                                print("jsonResult")
                                print(jsonResult)
                                print("all_stations")
                                print(all_stations)
                                print("number of stations")
                                print(num_of_stations)
                                print("station1")
                                print(station1_name)
                                print(station1_distance)
                                print(station1_reg_price)
                                print("station2")
                                print(station2_name)
                                print(station2_distance)
                                print(station2_reg_price)
                                print("station3")
                                print(station3_name)
                                print(station3_distance)
                                print(station3_reg_price)
                                
                                
                            } catch {
                                print("Json Processing Failed")
                            }
                        }
                    }
                }
                task.resume()
            }
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //BUTTON THAT TAKES USER TO MAPS APP : INCOMPLETE
    //LATITUDE AND LONGITUDE ARE HARDCODED
    /*
    @IBAction func go_to_maps(_ sender: UIButton) {
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
    */
    
    
}

