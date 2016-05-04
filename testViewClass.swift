//
//  ListViewController.swift
//  Späti
//
//  Created by Clemens Morris on 25/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import CoreLocation

class testViewClass: UIViewController, CLLocationManagerDelegate {

    var locationManage = CLLocationManager()
    
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var TableView: UITableView!
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    
    override func viewDidLoad() {
        
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.startUpdatingLocation()
        
        if (arrayofSpätis.count == 0){
            
            if (authorizationStatus == .AuthorizedWhenInUse){
                
                arrayofSpätis.removeAll()
                
                let annotationQuery = PFQuery(className: "Locations")
                
                currentLoc = PFGeoPoint(location: locationManage.location)
                annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 5)
                annotationQuery.findObjectsInBackgroundWithBlock{
                    (locations, error:NSError?) -> Void in
                    if error == nil {
                        
                        let myLocations = locations! as [PFObject]
                        for location in myLocations {
                            let point = location["location"] as! PFGeoPoint
                            let title = location["name"] as! String
                            let address = location["address"] as! String
                            let coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                            let thisSpäti = SpätiClass(name: title, address: address,coordinate: coordinate)
                            arrayofSpätis.append(thisSpäti)
                            self.TableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error)")
                    }
                }
                
                
            }
                
            else{
                
                
                let annotationQuery = PFQuery(className: "Locations")
                
                currentLoc = PFGeoPoint(latitude: 52.520295, longitude: 13.401604)
                annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 150)
                annotationQuery.findObjectsInBackgroundWithBlock{
                    (locations, error:NSError?) -> Void in
                    if error == nil {
                        
                        
                    let myLocations = locations! as [PFObject]
                    for location in myLocations {
                        let point = location["location"] as! PFGeoPoint
                        let title = location["name"] as! String
                        let address = location["address"] as! String
                        let coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                        let thisSpäti = SpätiClass(name: title, address: address,coordinate: coordinate)
                        arrayofSpätis.append(thisSpäti)
                        self.TableView.reloadData()
                        
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error)")
                    }
                }
            }
                
        }
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let Späti = arrayofSpätis[indexPath.row]
        
        let ViewController: detailedspätiView = self.storyboard!.instantiateViewControllerWithIdentifier("detailedspätiView") as! detailedspätiView
        
        ViewController.name = Späti.name
        ViewController.address = Späti.address
        ViewController.coordinate = Späti.coordinate
    
        presentViewController(ViewController, animated: false, completion: nil)
    }
}
