//
//  ShowResultsPage.swift
//  gas
//
//  Created by Ian Costello on 11/13/18.
//  Copyright © 2018 Kimber King. All rights reserved.
//

import UIKit

class ShowResultsPage: UIStoryboardSegue {

    override func perform() {
        swipe()
    }
    
    func swipe() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        //let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        
        toViewController.view.transform = CGAffineTransform(translationX: 375, y: 0)
        toViewController.view.center = originalCenter

        //containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: {
            
            fromViewController.view.transform = CGAffineTransform(translationX: -375, y: 0)
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
    
}
