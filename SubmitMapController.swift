//
//  SubmitMapController.swift
//  Späti
//
//  Created by Clemens Morris on 10/06/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MapKit


class SubmitMapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManage = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var callOut: UIImageView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    let location = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    let regionRadius: CLLocationDistance = 1500
    
    
    var currentcoordinate = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    override func viewDidLoad() {
     
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.startUpdatingLocation()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if (authorizationStatus == .AuthorizedWhenInUse){
        
            let initialLocations = locationManage.location
            
            centerMapOnLocation(initialLocations!)
            
        }
        else{
            
            let initialLocations = CLLocationCoordinate2DMake(52.520295, 13.401604)
            
            centerMapOnLocationDenied(initialLocations)
            
        }
        
        nameField.hidden = true
        submitButton.hidden = true
        callOut.hidden = true
        

        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(MKMapView.addAnnotation(_:)))
        uilgr.minimumPressDuration = 0.7
        uilgr.numberOfTouchesRequired = 1
        map.addGestureRecognizer(uilgr)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.endEditing(true)
            
        }
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        instructionLabel.text = "Great! Now select it to add a name!"
        
        if (map.annotations.count == 0){
            
            let touchPoint = gestureRecognizer.locationInView(map)
            let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
        }
        else {
            
            let annotationsToRemove = map.annotations.filter { $0 !== map.userLocation }
            map.removeAnnotations(annotationsToRemove)
            let touchPoint = gestureRecognizer.locationInView(map)
            let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
            
        }
        
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        instructionLabel.hidden = true
        
        if view.annotation!.isKindOfClass(MKUserLocation){
            
        }
        else{
        currentcoordinate = (view.annotation?.coordinate)!
        view.image = UIImage(named: "submiticonhighlight")
        nameField.hidden = false
        submitButton.hidden = false
        callOut.hidden = false
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.annotation!.isKindOfClass(MKUserLocation){
            
        }
        else{
        view.image = UIImage(named: "submiticon")
        nameField.hidden = true
        submitButton.hidden = true
        callOut.hidden = true
        textFieldShouldReturn(nameField)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = false
            annotationView!.image = UIImage(named: "submiticon")
            annotationView!.centerOffset = CGPointMake(0, -21.7)
            
        }
        else
        {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if(nameField.text != "add a name!" && nameField.text != ""){
            let name = nameField.text!
            _ = currentcoordinate
            let point = PFGeoPoint(latitude: currentcoordinate.latitude, longitude: currentcoordinate.longitude)
            
            let location = PFObject(className: "SubmitSpati")
            location.setObject(name, forKey: "Name")
            location.setObject(point, forKey: "Location")
            location.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    let ac = UIAlertController(title: "Thanks for Sharing!", message: "You're making this app even more useful!", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Go back to being awesome", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                } else {
                    
                    let ac = UIAlertController(title: "There seems to be a problem", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    print("Error: \(error) \(error!.userInfo)")
                }
            }
            
        }
        else {
            
            let ac = UIAlertController(title: "Information Missing", message: "Please add a name!", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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


}
