//
//  ListViewController.swift
//  Späti
//
//  Created by Clemens Morris on 25/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit

class testViewClass: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        
//        let nameQuery = PFQuery(className: "Locations")
//        nameQuery.addAscendingOrder("name")
//        nameQuery.findObjectsInBackgroundWithBlock{
//            (name, error:NSError?) -> Void in
//            if error == nil {
//                
//                let myName = name! as [PFObject]
//                for name in myName {
//                    
//                    let title = name["name"] as! String
//                    ViewController.names.append(title)
//                    
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error)")
//            }
//            
//        }

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("späticell", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.text = "\(names[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    @IBAction func reload(sender: AnyObject) {
        
        self.tableView.reloadData()
        print("reload")
        print(names.count)
        
    }
}
