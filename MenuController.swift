//
//  MenuController.swift
//
//
//  Created by Clemens Morris on 27/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MessageUI

class MenuController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "menupic-1")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
       
        self.tableview.backgroundView?.sizeToFit()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
   
    
    
}