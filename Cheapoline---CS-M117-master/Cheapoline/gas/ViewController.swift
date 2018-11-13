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
    
    var milesInputVal = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var milesInput: UITextField!

    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button.tag {
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
        case 3:
            if (selectedType == .none) {
                selectedType = .diesel }
            else if (selectedType == .diesel) {
                selectedType = .none }
            else {
                return }
        default:
            if (selectedType == .none) {
                selectedType = .regular }
            else if (selectedType == .regular) {
                selectedType = .none }
            else {
                return }
        }
        
        animateGasTypeSelection(button)
    }
    
    func animateGasTypeSelection(_ sender: UIButton) {
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
            
            milesInputVal = milesInput.text ?? "5"
            if milesInputVal == "" { milesInputVal="5"; milesInput.text="5" }
            // if Int(milesInputVal)! > 100 { milesInputVal = "100" }
            // DOES IT MAKE SENSE TO LIMIT RESULTS TO A CERTAIN RANGE TO AVOID
            // OVERLOADING THE API?
            
            var buildURLString = "http://devapi.mygasfeed.com/stations/radius/"
            buildURLString += "\(currentLocation.coordinate.latitude)"
            buildURLString += "/" + "\(currentLocation.coordinate.longitude)"
            buildURLString += "/" + "\(milesInputVal)"
            switch selectedType {
            case .medium:
                buildURLString += "/mid/price/rfej9napna.json?"
            case .premium:
                buildURLString += "/pre/price/rfej9napna.json?"
            case .diesel:
                buildURLString += "/diesel/price/rfej9napna.json?"
            default:
                buildURLString += "/reg/price/rfej9napna.json?"
            }
            
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
                                
                                //IMPLEMENTATION FOR WHEN N/A OCCURS
                                var countNAs = 0
                                var i = 0
                                while i < num_of_stations {
                                    let tempStation = all_stations[i] as! [String:Any]
                                    var price_check = ""
                                    switch self.selectedType {
                                    case .medium:
                                        price_check = tempStation["mid_price"] as! String
                                    case .premium:
                                        price_check = tempStation["pre_price"] as! String
                                    case .diesel:
                                        price_check = tempStation["diesel_price"] as! String
                                    default:
                                        price_check = tempStation["reg_price"] as! String
                                    }
                                    if ((price_check) == "N/A") {
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
                                
                                var station1, station2, station3: [String:Any]
                                var station1_name="", station2_name="", station3_name=""
                                var station1_distance="", station2_distance="", station3_distance=""
                                var station1_reg_price="", station2_reg_price="", station3_reg_price=""
                                var station1_mid_price="", station2_mid_price="", station3_mid_price=""
                                var station1_pre_price="", station2_pre_price="", station3_pre_price=""
                                var station1_diesel_price="", station2_diesel_price="", station3_diesel_price=""
                                
                                if good_stations.count >= 1 {
                                //FOR STATION 1
                                station1 = good_stations[0] as! [String:Any]
                                station1_name = station1["station"] as? String ?? "No Name Found"
                                station1_distance = station1["distance"] as! String
                                station1_reg_price = station1["reg_price"] as! String
                                station1_mid_price = station1["mid_price"] as! String
                                station1_pre_price = station1["pre_price"] as! String
                                station1_diesel_price = station1["diesel_price"] as! String
                                }
                                
                                if good_stations.count >= 2 {
                                //FOR STATION 2
                                station2 = good_stations[1] as! [String:Any]
                                station2_name = station2["station"] as? String ?? "No Name Found"
                                station2_distance = station2["distance"] as! String
                                station2_reg_price = station2["reg_price"] as! String
                                station2_mid_price = station2["mid_price"] as! String
                                station2_pre_price = station2["pre_price"] as! String
                                station2_diesel_price = station2["diesel_price"] as! String
                                }
                                
                                if good_stations.count >= 3 {
                                //FOR STATION 3
                                station3 = good_stations[2] as! [String:Any]
                                station3_name = station3["station"] as? String ?? "No Name Found"
                                station3_distance = station3["distance"] as! String
                                station3_reg_price = station3["reg_price"] as! String
                                station3_mid_price = station3["mid_price"] as! String
                                station3_pre_price = station3["pre_price"] as! String
                                station3_diesel_price = station3["diesel_price"] as! String
                                }
                                
                                print("jsonResult")
                                print(jsonResult)
                                print("all_stations")
                                print(all_stations)
                                print("number of stations")
                                print(num_of_stations)
                                if num_of_stations >= 1 {
                                print("station1")
                                print(station1_name)
                                print(station1_distance)
                                switch self.selectedType {
                                case .medium:
                                    print(station1_mid_price)
                                case .premium:
                                    print(station1_pre_price)
                                case .diesel:
                                    print(station1_diesel_price)
                                default:
                                    print(station1_reg_price)
                                }
                                }
                                if num_of_stations >= 2 {
                                print("station2")
                                print(station2_name)
                                print(station2_distance)
                                switch self.selectedType {
                                case .medium:
                                    print(station2_mid_price)
                                case .premium:
                                    print(station2_pre_price)
                                case .diesel:
                                    print(station2_diesel_price)
                                default:
                                    print(station2_reg_price)
                                }
                                }
                                if num_of_stations >= 3 {
                                print("station3")
                                print(station3_name)
                                print(station3_distance)
                                switch self.selectedType {
                                case .medium:
                                    print(station3_mid_price)
                                case .premium:
                                    print(station3_pre_price)
                                case .diesel:
                                    print(station3_diesel_price)
                                default:
                                    print(station3_reg_price)
                                }
                                }
                                
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

