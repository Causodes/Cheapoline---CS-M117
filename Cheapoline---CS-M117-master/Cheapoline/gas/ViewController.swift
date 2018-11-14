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
    
    struct station {
        var name: String
        var distance: String
        var price: String
        var lat: String
        var lng: String
    }
    
    var station1 = station(name: "", distance: "", price: "", lat: "", lng: "")
    var station2 = station(name: "", distance: "", price: "", lat: "", lng: "")
    var station3 = station(name: "", distance: "", price: "", lat: "", lng: "")

    
    
    @IBOutlet weak var logo: UIImageView!
    
    
    
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
        
        var count = 0
        var find_done = false
        while (count < 10) {
            find_helper(sender, withCompletion: {stations, error in
                if error != nil {
                    //handle error
                } else if (stations != nil){
                    self.parseJSON(stations!, Station1: &self.station1, Station2: &self.station2, Station3: &self.station3)
                    find_done = true
                }
            })
            count += 1
        }
        while (!find_done) {
            /* I know, I know. Spin-lock!? Yes. I'm hungry. */ }
        
        performSegue(withIdentifier: "ShowResults", sender: self)
    }

    /*  I intended to animate the logo as a loading symbol, but have not yet figure out how to make the animation play while the program is busy getting the JSON
    func animateCheapolineLogo() {
        UIView.animate(withDuration: 0.15, delay: Double.random(in: 0..<0.2), options: .curveLinear, animations: {
            self.logo.transform = CGAffineTransform(scaleX: CGFloat(Double.random(in:0.2..<0.8)), y: CGFloat(Double.random(in:0.2..<0.8)))
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat(Double.random(in:1.5..<3.1416)/3))
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
                self.logo.transform = .identity
            }, completion: nil)
        }
        /*if sender.isSelected {
         sender.isSelected = false
         } else {
         sender.isSelected  = true
         }*/
    }*/
    
    
    
    
    
    
    func find_helper(_ sender: Any, withCompletion completion: @escaping ([Any]?, Error?) -> Void) {
        
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
                        completion(nil, error)
                        return
                    } else {
                        if let urlContent = data {
                            do {
                                guard let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: []) as? [String: AnyObject] else {completion(nil, nil);return}
                                
                                guard let all_stations = jsonResult["stations"] as? [Any] else {completion(nil, nil);return}
                                completion(all_stations, nil)
                                
                            } catch {
                                //print("Json Processing Failed")
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
    
    func parseJSON(_ all_stations: [Any], Station1: inout station, Station2: inout station, Station3: inout station) {
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
        var station1_lat="", station2_lat="", station3_lat=""
        var station1_lng="", station2_lng="", station3_lng=""
        
        if good_stations.count >= 1 {
            //FOR STATION 1
            station1 = good_stations[0] as! [String:Any]
            station1_name = station1["station"] as? String ?? "No Name Found"
            station1_distance = station1["distance"] as! String
            station1_reg_price = station1["reg_price"] as! String
            station1_mid_price = station1["mid_price"] as! String
            station1_pre_price = station1["pre_price"] as! String
            station1_diesel_price = station1["diesel_price"] as! String
            station1_lat = station1["lat"] as! String
            station1_lng = station1["lng"] as! String
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
            station2_lat = station2["lat"] as! String
            station2_lng = station2["lng"] as! String
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
            station3_lat = station3["lat"] as! String
            station3_lng = station3["lng"] as! String
        }
        
        if num_of_stations >= 1 {
            Station1.name = station1_name
            Station1.distance = station1_distance
            switch self.selectedType {
            case .medium:
                Station1.price = station1_mid_price
            case .premium:
                Station1.price = station1_pre_price
            case .diesel:
                Station1.price = station1_diesel_price
            default:
                Station1.price = station1_reg_price
            }
            Station1.lat = station1_lat
            Station1.lng = station1_lng
        }
        if num_of_stations >= 2 {
            Station2.name = station2_name
            Station2.distance = station2_distance
            switch self.selectedType {
            case .medium:
                Station2.price = station2_mid_price
            case .premium:
                Station2.price = station2_pre_price
            case .diesel:
                Station2.price = station2_diesel_price
            default:
                Station2.price = station2_reg_price
            }
            Station2.lat = station2_lat
            Station2.lng = station2_lng
        }
        if num_of_stations >= 3 {
            Station3.name = station3_name
            Station3.distance = station3_distance
            switch self.selectedType {
            case .medium:
                Station3.price = station3_mid_price
            case .premium:
                Station3.price = station3_pre_price
            case .diesel:
                Station3.price = station3_diesel_price
            default:
                Station3.price = station3_reg_price
            }
            Station3.lat = station3_lat
            Station3.lng = station3_lng
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var results_vc = segue.destination as! ResultsViewController
        
        // Consider creating copy constructor for station lol
        results_vc.station1.name = station1.name; results_vc.station1.price = station1.price; results_vc.station1.distance = station1.distance; results_vc.station1.lat = station1.lat; results_vc.station1.lng = station1.lng
        results_vc.station2.name = station2.name; results_vc.station2.price = station2.price; results_vc.station2.distance = station2.distance; results_vc.station2.lat = station2.lat; results_vc.station2.lng = station2.lng
        results_vc.station3.name = station3.name; results_vc.station3.price = station3.price; results_vc.station3.distance = station3.distance; results_vc.station3.lat = station3.lat; results_vc.station3.lng = station3.lng
        
        switch selectedType {
        case .medium:
            results_vc.selectedType = .medium
        case .premium:
            results_vc.selectedType = .premium
        case .diesel:
            results_vc.selectedType = .diesel
        default:
            results_vc.selectedType = .regular
        }
    }
    
}

