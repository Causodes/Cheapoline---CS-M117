//
//  ResultsViewController.swift
//  gas
//
//  Created by Ian Costello on 11/13/18.
//  Copyright © 2018 Kimber King. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var Station1_Name: UILabel!
    @IBOutlet weak var Station1_Price: UILabel!
    @IBOutlet weak var Station1_Distance: UILabel!
    
    @IBOutlet weak var Station2_Name: UILabel!
    @IBOutlet weak var Station2_Price: UILabel!
    @IBOutlet weak var Station2_Distance: UILabel!
    
    @IBOutlet weak var Station3_Name: UILabel!
    @IBOutlet weak var Station3_Price: UILabel!
    @IBOutlet weak var Station3_Distance: UILabel!
    
    
    @IBOutlet weak var station1_view: UIView!
    @IBOutlet weak var station2_view: UIView!
    @IBOutlet weak var station3_view: UIView!
    @IBOutlet weak var google_view: UIButton!
    @IBOutlet weak var back_view: UIButton!
    
    
    
    @IBOutlet weak var Station1_Checkbox: UIButton!
    
    
    enum gasTypes { case regular, medium, premium, diesel, none }
    var selectedType = gasTypes.none
    enum stationEnum { case one, two, three, none }
    var selectedStation = stationEnum.none
    
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
    
    func gasTypeToString(gasType: gasTypes) -> String {
        switch gasType {
        case .medium:
            return "medium"
        case .premium:
            return "premium"
        case .diesel:
            return "diesel"
        default:
            return "regular"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedTypeString = gasTypeToString(gasType: selectedType)
        Station1_Name.text = station1.name; Station1_Price.text = "Cost of " + selectedTypeString + ": " + station1.price; Station1_Distance.text = station1.distance + " away"
        Station2_Name.text = station2.name; Station2_Price.text = "Cost of " + selectedTypeString + ": " + station2.price; Station2_Distance.text = station2.distance + " away"
        Station3_Name.text = station3.name; Station3_Price.text = "Cost of " + selectedTypeString + ": " + station3.price; Station3_Distance.text = station3.distance + " away"
        
        if (station1.name == "") {
            Station1_Name.text = "No Stations Found"; Station1_Price.text = "Please try again."; Station1_Distance.text = "Try increasing range."
            Station1_Checkbox.isHidden = true
        }
        
            
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.station1_view.isHidden = true
        self.station2_view.isHidden = true
        self.station3_view.isHidden = true
        self.google_view.isHidden = true
        self.back_view.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.station1_view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.station2_view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.station3_view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.google_view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.back_view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.station1_view.isHidden = false
            self.station1_view.transform = .identity
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.google_view.isHidden = false
            self.google_view.transform = .identity
        })
        }
        if (station2.name != "") { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.station2_view.isHidden = false
            self.station2_view.transform = .identity
        })
        }}
        if (station3.name != "") { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.station3_view.isHidden = false
            self.station3_view.transform = .identity
        })
        }}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.back_view.isHidden = false
            self.back_view.transform = .identity
        })
        }

    }
    

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button.tag {
        case 0:
            if (selectedStation == .none) {
                selectedStation = .one }
            else if (selectedStation == .one) {
                selectedStation = .none }
            else {
                return }
        case 1:
            if (selectedStation == .none) {
                selectedStation = .two }
            else if (selectedStation == .two) {
                selectedStation = .none }
            else {
                return }
        default:
            if (selectedStation == .none) {
                selectedStation = .three }
            else if (selectedStation == .three) {
                selectedStation = .none }
            else {
                return }
        }
        
        animateStationSelection(button)
    }
    
    func animateStationSelection(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0.05, options: .curveLinear, animations: {
            //sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
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
    
    
    @IBAction func OpenInGoogleMaps(_ sender: Any) {
        var latitude = "", longitude = ""
        switch selectedStation {
        case .one:
            latitude = station1.lat; longitude = station1.lng
        case .two:
            latitude = station2.lat; longitude = station2.lng
        case .three:
            latitude = station3.lat; longitude = station3.lng
        default:
            return
        }
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
