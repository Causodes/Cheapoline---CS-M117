//
//  ViewController.swift
//  gas
//
//  Created by Kimber King on 11/8/18.
//  Copyright © 2018 Kimber King. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation:  CLLocation!
    
    enum gasTypes { case regular, medium, premium, diesel, none }
    var selectedType = gasTypes.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button.tag {
        case 0:
            if (selectedType == .none) {
                selectedType = .regular }
            else if (selectedType == .regular) {
                selectedType = .none }
            else {
                return }
        case 1:
            if (selectedType == .none) {
                selectedType = .medium }
            else if (selectedType == .medium) {
                selectedType = .none }
            else {
                return }
        case 2:
            if (selectedType == .none) {
                selectedType = .premium }
            else if (selectedType == .premium) {
                selectedType = .none }
            else {
                return }
        default:
            if (selectedType == .none) {
                selectedType = .diesel }
            else if (selectedType == .diesel) {
                selectedType = .none }
            else {
                return }
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.05, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        /*if sender.isSelected {
         sender.isSelected = false
         } else {
         sender.isSelected  = true
         }*/
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion =
            MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10, longitudinalMeters:10)
        //mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    

    @IBAction func find(_ sender: Any) {
    //}
    //@IBAction func getLocation(_ sender: UIButton) {
        //"start" getting location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location
            
            
            var buildURLString = "http://devapi.mygasfeed.com/stations/radius/"
            buildURLString += "\(currentLocation.coordinate.latitude)"
            buildURLString += "/" + "\(currentLocation.coordinate.longitude)"
            buildURLString += "/5/reg/price/rfej9napna.json?"
            //location_value.text = buildURLString
            
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
                                var countNAs = 0
                                var i = 0
                                while i < num_of_stations {
                                    let tempStation = all_stations[i] as! [String:Any]
                                    let temp_reg_price = tempStation["reg_price"]
                                    if ((temp_reg_price as! String) == "N/A") {
                                        countNAs += 1
                                    } else { break }
                                    i += 1
                                }
                                i = 0
                                var good_stations = all_stations
                                while i < countNAs {
                                    good_stations.remove(at: 0)
                                    i += 1
                                }
                                
                                
                                
                                //FOR STATION 1
                                let station1 = good_stations[0] as! [String:Any]
                                let station1_name = station1["station"] as AnyObject
                                let station1_distance = station1["distance"] as AnyObject
                                let station1_reg_price = station1["reg_price"] as AnyObject
                                let station1_mid_price = station1["mid_price"] as AnyObject
                                let station1_pre_price = station1["pre_price"] as AnyObject
                                let station1_diesel_price = station1["diesel_price"] as AnyObject
                                
                                //FOR STATION 2
                                let station2 = good_stations[1] as! [String:Any]
                                let station2_name = station2["station"] as AnyObject
                                let station2_distance = station2["distance"] as AnyObject
                                let station2_reg_price = station2["reg_price"] as AnyObject
                                let station2_mid_price = station2["mid_price"] as AnyObject
                                let station2_pre_price = station2["pre_price"] as AnyObject
                                let station2_diesel_price = station2["diesel_price"] as AnyObject
                                
                                //FOR STATION 3
                                let station3 = good_stations[2] as! [String:Any]
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
    

}

