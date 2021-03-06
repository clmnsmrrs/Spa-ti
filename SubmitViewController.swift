//
//  SubmitViewController.swift
//  Späti
//
//  Created by Clemens Morris on 02/05/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit

class SubmitViewController: UITableViewController, CLLocationManagerDelegate {
    
    var name = "no name given"
    var address = "no name given"
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var locationField: UITextField!
    
    @IBAction func submitSpäti(sender: AnyObject) {
        
        if(nameField.text != "" && locationField.text != ""){
            name = nameField.text!
            address = locationField.text!
        
            let location = PFObject(className: "SubmitSpati")
            location.setObject(name, forKey: "Name")
            location.setObject(address, forKey: "Address")
            location.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    let ac = UIAlertController(title: "Thanks for Sharing!", message: "You're making this app even more useful!", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Go back to being awesome", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                } else {
                    
                    let ac = UIAlertController(title: "There seems to be a problem", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print("Error: \(error) \(error!.userInfo)")
                }
            }
            
        }
        else {
            
            let ac = UIAlertController(title: "Information Missing", message: "Please add details to all fields", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
    
    
    

