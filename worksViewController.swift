//
//  worksViewController.swift
//  Späti
//
//  Created by Clemens Morris on 25/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit

class worksViewController: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
    
    if self.revealViewController() != nil {
    menuButton.target = self.revealViewController()
    menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    }
}
