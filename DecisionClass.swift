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
       
    }
    
    @IBAction func decisionButton(sender: AnyObject) {

        if(decisionbutton.currentTitle == "Enable User Location"){
            
            locationManage.requestWhenInUseAuthorization()
            
            decisionbutton.setTitle("GET STARTED", forState: UIControlState.Normal)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")
            
            
            
        }
        else{
            let ViewControllerfirst: SWRevealViewController = self.storyboard!.instantiateViewControllerWithIdentifier("start") as! SWRevealViewController
            
            presentViewController(ViewControllerfirst, animated: true, completion: nil)
            
            
        }

    }
    
}
