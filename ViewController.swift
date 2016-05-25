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
import GoogleMobileAds


var arrayofSpätis = [SpätiClass]()


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GADInterstitialDelegate{
    
    var interstitial: GADInterstitial?
    
    var interstitialcounter = 4
    
    var locationManage = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    let location = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    let regionRadius: CLLocationDistance = 1500
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var greencolor = UIColor(red:0.30, green:0.86, blue:0.60, alpha:1.0)
    
    let reuseIdentifier = "spati"
    
    @IBOutlet weak var locationsButton: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let tutorial:Bool = NSUserDefaults.standardUserDefaults().boolForKey("tutorial")
    
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("tutorial")==true){
            
        }
        else
        {
            let ViewController: NavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("DecisionViewController") as! NavigationController
            
            presentViewController(ViewController, animated: true, completion: nil)
        }
        
        
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        loadInterstitial()
        
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.startUpdatingLocation()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
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
        
        else if (authorizationStatus == .Denied ){
            
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
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
        
        interstitialcounter = interstitialcounter - 1
        
        if (interstitialcounter == 0 ){
            
            if(interstitial!.isReady){
            print("now")
            interstitial!.presentFromRootViewController(self)
            }
            
            else{
                
                interstitialcounter = 2
                print("not loaded yet")
                
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        

        let placeName = view.annotation?.title
        let placeInfo = view.annotation?.subtitle
        
        let routeaction = UIAlertAction(title: "Route", style: .Default) { (action) in
            
            let thiscoordinate = view.annotation?.coordinate
            let regionDistance:CLLocationDistance = 10000
            
            let regionSpan = MKCoordinateRegionMakeWithDistance(thiscoordinate!, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: thiscoordinate!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = (view.annotation?.title)!
            mapItem.openInMapsWithLaunchOptions(options)
            
        }
 
        let ac = UIAlertController(title: placeName!, message: placeInfo!, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
        ac.addAction(routeaction)
        presentViewController(ac, animated: true, completion: nil)
        
        print("pressed the detail button")
    }
    
    
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
            detailButton.tintColor = greencolor
        
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

    private func loadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial!.delegate = self
        interstitial!.loadRequest(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
