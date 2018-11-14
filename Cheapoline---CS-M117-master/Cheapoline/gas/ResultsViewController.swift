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
        
        
        // Do any additional setup after loading the view.
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
