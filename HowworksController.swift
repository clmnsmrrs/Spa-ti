//
//  HowworksController.swift
//  Späti
//
//  Created by Clemens Morris on 27/05/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit

class HowworksController: UITableViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        let backgroundImage = UIImage(named: "blurberlin")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
}
