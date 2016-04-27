//
//  NavigationController.swift
//  Späti
//
//  Created by Clemens Morris on 23/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var greencolor = UIColor(red:0.30, green:0.86, blue:0.60, alpha:1.0)
    
    override func viewDidAppear(animated: Bool) {
        
        navigationBar.barTintColor = greencolor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

    }
    
    
    
    
}
