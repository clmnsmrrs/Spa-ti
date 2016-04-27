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

        if(decisionbutton.currentTitle == "Make That Decision"){
            
            locationManage.requestWhenInUseAuthorization()
            decisionbutton.setTitle("Done", forState: UIControlState.Normal)
            
        }
        else{
            
            let ViewControllerfirst: NavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! NavigationController
            
            presentViewController(ViewControllerfirst, animated: true, completion: nil)
            
        }
        
}
    
    
}
