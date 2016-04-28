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
        
        let cell: SpätiCell = tableView.dequeueReusableCellWithIdentifier("späticell") as! SpätiCell
        
        let Späti = arrayofSpätis[indexPath.row]
        
        cell.nameLabel.text = Späti.name
        cell.addressLabel.text = Späti.address
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofSpätis.count
    }
    
    @IBAction func reload(sender: AnyObject) {
        
        self.tableView.reloadData()
        print("reload")
        print(arrayofSpätis.count)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let Späti = arrayofSpätis[indexPath.row]
        
        let ViewController: detailedspätiView = self.storyboard!.instantiateViewControllerWithIdentifier("detailedspätiView") as! detailedspätiView
        
        ViewController.name = Späti.name
        ViewController.address = Späti.address
        ViewController.coordinate = Späti.coordinate
    
        presentViewController(ViewController, animated: false, completion: nil)
    }
}
