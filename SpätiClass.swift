//
//  SpätiClass.swift
//  Späti
//
//  Created by Clemens Morris on 27/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import Foundation

class SpätiClass {
    
    var name = "name"
    var address = "address"
    var coordinate = CLLocationCoordinate2DMake(2.3, 2.5)
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D){
        
        self.name = name
        self.address = address
        self.coordinate = coordinate
        
    }
    
    
    
}