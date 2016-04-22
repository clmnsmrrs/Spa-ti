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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var locationManage = CLLocationManager()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    let location = CLLocationCoordinate2D(latitude: 37.3317115, longitude: -122.0301835)
    
    let regionRadius: CLLocationDistance = 1500
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.textAlignment = NSTextAlignment.Center
        
        locationManage.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        locationManage.requestWhenInUseAuthorization()
        locationManage.startUpdatingLocation()
        
        let initialLocations = locationManage.location
        
        centerMapOnLocation(initialLocations!)
        
    }
    
    func spätiView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("späti")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "späti")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "späti.png")
        
        return annotationView
        
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  self.regionRadius * 2.0, self.regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        let annotationQuery = PFQuery(className: "Locations")
        
        currentLoc = PFGeoPoint(location: locationManage.location)
        annotationQuery.whereKey("location", nearGeoPoint: currentLoc, withinMiles: 2)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
