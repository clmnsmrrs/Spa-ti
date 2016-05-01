//
//  detailedspätiView.swift
//  Späti
//
//  Created by Clemens Morris on 27/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MapKit

class detailedspätiView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    var name: String!
    var address: String?
    var coordinate: CLLocationCoordinate2D?
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet var locationMapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManage = CLLocationManager()
    
    override func viewDidLoad() {
        
        locationManage.delegate = self
        nameLabel.text = name
        addressLabel.text = address
        centerMapOnLocation(coordinate!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = name!
        locationMapView.addAnnotation(annotation)
        
    }
    
    @IBAction func routetoLocation(sender: AnyObject) {
        
        let thiscoordinate = coordinate
        let regionDistance:CLLocationDistance = 10000
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(thiscoordinate!, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: thiscoordinate!, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.name)"
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, self.regionRadius * 2.0, self.regionRadius * 2.0)
        self.locationMapView.setRegion(coordinateRegion, animated: true)
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
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "spati")
            annotationView!.centerOffset = CGPointMake(0, -21.7)
        }
        else
        {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
//        let ViewController: testViewClass = self.storyboard!.instantiateViewControllerWithIdentifier("testViewClass") as! testViewClass
//        
//        presentViewController(ViewController, animated: false, completion: nil)
        
    }
    

}
