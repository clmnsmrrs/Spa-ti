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
    
    let regionRadius: CLLocationDistance = 800
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var greencolor = UIColor(red:0.30, green:0.86, blue:0.60, alpha:1.0)
    
    let reuseIdentifier = "spati"
    
    @IBOutlet weak var nothingLabel: UILabel!
    
    @IBOutlet weak var locationsButton: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let tutorial:Bool = NSUserDefaults.standardUserDefaults().boolForKey("notificationss")
    
    @IBOutlet weak var moreInfo: UIButton!

    @IBOutlet weak var AdressLabel: UILabel!
    
    @IBOutlet weak var SpätiImage: UIImageView!
    
    @IBOutlet weak var RouteButton: UIButton!
    
    var currentname = "name"
    
    var currentadress = "adress"
    
    var currentcoordinate = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AdressLabel.hidden = true
        moreInfo.hidden = true
        SpätiImage.hidden = true
        RouteButton.hidden = true
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("notificationss")==true){
            
        }
        else
        {
            let ViewController: NavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("DecisionViewController") as! NavigationController
            
            presentViewController(ViewController, animated: true, completion: nil)
        }
        
        bannerView.adUnitID = "ca-app-pub-6331937442442230/5091136903"
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
            annotationQuery.limit = 2000
            
            currentLoc = PFGeoPoint(location: locationManage.location)
            annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 1500)
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
                        self.nothingLabel.hidden = true
                        self.map.addAnnotation(annotation)
                        print(arrayofSpätis.count)
                    }
                } else {
                    
                    let ac = UIAlertController(title: "There seems to be a problem", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print("Error: \(error) \(error!.userInfo)")
                    self.nothingLabel.text = "Please reload the page!"
                }
            }

            
        }
        
        else if (authorizationStatus == .Denied ){
            
            locationsButton.hidden = true
            
            let initialLocations = CLLocationCoordinate2DMake(52.520295, 13.401604)
            
            centerMapOnLocationDenied(initialLocations)
            
            
            let annotationQuery = PFQuery(className: "Locations")
            
            currentLoc = PFGeoPoint(latitude: 52.520295, longitude: 13.401604)
            annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 1500)
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
                        self.nothingLabel.hidden = true
                        
                        self.map.addAnnotation(annotation)
                    }
                } else {
                    
                    let ac = UIAlertController(title: "There seems to be a problem", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print("Error: \(error) \(error!.userInfo)")
                    self.nothingLabel.text = "Please reload the page!"
                }
                
            }
            
            
        }
            
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.annotation!.isKindOfClass(MKUserLocation){
            
        }
        else{
        AdressLabel.hidden = true
        SpätiImage.hidden = true
        moreInfo.hidden = true
        RouteButton.hidden = true
        view.image = UIImage(named: "spati")
        }
    }
    
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
       
        if view.annotation!.isKindOfClass(MKUserLocation){
            
        }
        else{
        currentadress = ((view.annotation?.subtitle)!)!
        currentname = ((view.annotation?.title)!)!
        currentcoordinate = (view.annotation?.coordinate)!
        view.image = UIImage(named: "selectedspäti")
        AdressLabel.text = (view.annotation?.title)!
        AdressLabel.hidden = false
        SpätiImage.hidden = false
        RouteButton.hidden = false
        moreInfo.hidden = false
        }
        interstitialcounter = interstitialcounter - 1
        
        if (interstitialcounter == 0 ){
            
            if(interstitial!.isReady){
            
            interstitial!.presentFromRootViewController(self)
            }
            
            else{
                
                interstitialcounter = 2
                
            }
        }
        
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
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = false
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
        
        relocate()
        
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

    private func loadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6331937442442230/9516919302")
        interstitial!.delegate = self
        interstitial!.loadRequest(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func relocate(){
        
        let initialLocations = locationManage.location
        
        centerMapOnLocation(initialLocations!)
        
    }
    
    func showmessage() -> (){
        
        let ac = UIAlertController(title: "You didn't want to share your location and that's ok!", message: "if you change your mind, you can allow it in your System Settings!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default;
    }
    
    @IBAction func routeButtonAction(sender: AnyObject) {
        
        let thiscoordinate = currentcoordinate
        let regionDistance:CLLocationDistance = 10000
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(thiscoordinate, regionDistance, regionDistance)
        let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
                    ]
        let placemark = MKPlacemark(coordinate: thiscoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = currentname
            mapItem.openInMapsWithLaunchOptions(options)
        
    }
    
    
    @IBAction func reportButton(sender: AnyObject) {
       
        let report = UIAlertAction(title: "Report", style: .Destructive) { (action) in
            
            let location = PFObject(className: "ReportSpati")
            location.setObject(self.currentname, forKey: "Name")
            location.setObject(self.currentadress, forKey: "Address")
            location.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    let ac = UIAlertController(title: "Thanks for Sharing!", message: "You're making this app even more useful!", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Go back to being epic", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                } else {
                    
                    let ac = UIAlertController(title: "There seems to be a problem", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print("Error: \(error) \(error!.userInfo)")
                }
            }
            
        }
        
        let ac = UIAlertController(title: "Report Späti?", message: "Does this Späti no longer exist?", preferredStyle: .Alert)
        ac.addAction(report)
        ac.addAction(UIAlertAction(title: "Go Back", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
    }


}