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

    
    var clock:NSTimer = NSTimer()
    let locationManage = CLLocationManager()
    
    @IBOutlet weak var decisionbutton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManage.delegate = self
        clock = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(DecisionClass.checkStatus), userInfo: nil, repeats: true)
        clock.fire()
    }
    
    func checkStatus(){
        
        
        
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse){
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Badge , .Sound , .Alert], categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            clock.invalidate()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")
            
            let ViewControllerfirst: SWRevealViewController = self.storyboard!.instantiateViewControllerWithIdentifier("start") as! SWRevealViewController
            
            presentViewController(ViewControllerfirst, animated: true, completion: nil)
            
        }
        else if (CLLocationManager.authorizationStatus() == .Denied){
            
            clock.invalidate()
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Badge , .Sound , .Alert], categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")

            let ac = UIAlertController(title: "You didn't want to share your location and that's ok!", message: "if you change your mind, you can allow it in your System Settings!", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                let ViewControllerfirst: SWRevealViewController = self.storyboard!.instantiateViewControllerWithIdentifier("start") as! SWRevealViewController
                
                self.presentViewController(ViewControllerfirst, animated: true, completion: nil)
            })
            
            ac.addAction(action)
            self.presentViewController(ac, animated: true, completion: nil)
            
        }
        
        else {
            
            
        }
    }
    
    
    
    @IBAction func decisionButton(sender: AnyObject) {

            
            locationManage.requestWhenInUseAuthorization()
            
        }
    
}
