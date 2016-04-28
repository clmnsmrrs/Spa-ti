//
//  ViewController.swift
//  Späti
//
//  Created by Clemens Morris on 14/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var arrayofSpätis = [SpätiClass]()

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var locationManage = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    let location = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    let regionRadius: CLLocationDistance = 1500
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var greencolor = UIColor(red:0.30, green:0.86, blue:0.60, alpha:1.0)
    
    let reuseIdentifier = "spati"
    
    var animationarray = [UIImage(named: "button17"), UIImage(named: "button16"), UIImage(named: "button15"), UIImage(named: "button14"), UIImage(named: "button13"), UIImage(named: "button12"), UIImage(named: "button11"), UIImage(named: "button10"), UIImage(named: "button9"), UIImage(named: "button8"), UIImage(named: "button7"), UIImage(named: "button6"), UIImage(named: "button5"), UIImage(named: "button4"), UIImage(named: "button3"), UIImage(named: "button2"), UIImage(named: "button1")]
    
   @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var locationsButton: UIButton!
    
    let tutorial:Bool = NSUserDefaults.standardUserDefaults().boolForKey("tutorial")
    
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("tutorial")==true){
            
        }
        else
        {
            let ViewController: DecisionClass = self.storyboard!.instantiateViewControllerWithIdentifier("DecisionViewController") as! DecisionClass
            
            presentViewController(ViewController, animated: true, completion: nil)
        }
        
        

        
        self.navigationController?.navigationBar.barTintColor = greencolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.startUpdatingLocation()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .Authorized:
            print("authorized")
        case .AuthorizedWhenInUse:
            print("authorized when in use")
        case .Denied:
            print("denied")
        case .NotDetermined:
            print("not determined")
        case .Restricted:
            print("restricted")
        }
        
        if (authorizationStatus == .AuthorizedWhenInUse){
        
            let initialLocations = locationManage.location
            
            centerMapOnLocation(initialLocations!)
            
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
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                        annotation.title = title
                        annotation.subtitle = address
                        let thisSpäti = SpätiClass(name: title, address: address,coordinate: annotation.coordinate)
                        arrayofSpätis.append(thisSpäti)
                        self.map.addAnnotation(annotation)
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error)")
                }
            }

            
        }
        
        else{
            
            locationsButton.hidden = true
            
            let initialLocations = CLLocationCoordinate2DMake(52.520295, 13.401604)
            
            centerMapOnLocationDenied(initialLocations)
            
            
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
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                        annotation.title = title
                        
                        self.map.addAnnotation(annotation)
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error)")
                }
            }

            
            
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
        
        print("Selected annotation")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
//        let tappedSpäti = view.annotation as! SpätiClass
        let placeName = view.annotation?.title
        let placeInfo = "test this shit out"
        
        let ac = UIAlertController(title: placeName!, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
        //put a view controller here with the correct information
        print("pressed the detail button")
    }
    
    
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "spati")
            annotationView!.rightCalloutAccessoryView = detailButton
            annotationView!.centerOffset = CGPointMake(0, -21.7)
        }
        else
        {
            annotationView!.annotation = annotation
        }
        return annotationView
    }

    
    @IBAction func findLocation(sender: AnyObject) {
        
        let initialLocations = locationManage.location
        
        centerMapOnLocation(initialLocations!)
        
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
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    annotation.title = title
                    annotation.subtitle = address
                    let thisSpäti = SpätiClass(name: title, address: address,coordinate: annotation.coordinate)
                    arrayofSpätis.append(thisSpäti)
                    self.map.addAnnotation(annotation)
                }

            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
        
        
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  self.regionRadius * 2.0, self.regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnLocationDenied(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(52.520295, 13.401604), self.regionRadius * 2.0, self.regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
