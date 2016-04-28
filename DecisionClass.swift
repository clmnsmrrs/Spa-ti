//
//  DecisionClass.swift
//  Späti
//
//  Created by Clemens Morris on 26/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import CoreLocation

class DecisionClass: UIViewController, CLLocationManagerDelegate{

    let locationManage = CLLocationManager()
    
    @IBOutlet weak var decisionbutton: UIButton!
    override func viewDidAppear(animated: Bool) {
        
        locationManage.delegate = self
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")
    }
    
    @IBAction func decisionButton(sender: AnyObject) {

        if(decisionbutton.currentTitle == "Enable User Location"){
            
            locationManage.requestWhenInUseAuthorization()
            
            decisionbutton.setTitle("GET STARTED", forState: UIControlState.Normal)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")
            
            
            
        }
        else{
            let ViewControllerfirst: NavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! NavigationController
            
            presentViewController(ViewControllerfirst, animated: true, completion: nil)
            
            
        }

    }
    
}
