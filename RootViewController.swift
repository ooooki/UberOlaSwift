//
//  RootViewController.swift
//  tesaeraa
//
//  Created by Sandeep Rathod on 10/26/17.
//  Copyright © 2017 TEst. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation

class RootViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var camera = GMSCameraPosition()
    var marker = GMSMarker()
    var oldLocation:CLLocationCoordinate2D!
    var newLocation:CLLocationCoordinate2D!
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.blue
        
        navigationItem.title = "Hello Map"
        
        camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //marker.icon = [UIImage imageNamed:@"carIcon"];
        
        oldLocation = camera.target

        marker = GMSMarker()
        marker.icon = UIImage.init(named: "carIcon")
        marker.position = camera.target
        //marker.snippet = "Hello World"
        //marker.appearAnimation = GMSMarkerAnimation
        marker.map = mapView
        
        view = mapView
        
        startLocationTracking()
        
        
        
    }
        
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLocationTracking() {
        
        

            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            //locationManager.distanceFilter = 200;
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

            
            
            
           

        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error is = \(error.localizedDescription)")
        
    }
    
func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
       camera = GMSCameraPosition.camera(withLatitude:locValue.latitude,
                                          longitude: locValue.longitude,
                                          zoom: 14)
        mapView.animate(to: camera)


        newLocation = (manager.location?.coordinate)!
        print("Current Locations = \(newLocation.latitude) \(newLocation.longitude)")
        
        let getAngle = getHeadingForDirection(fromCoordinate: oldLocation, toCoordinate: newLocation)
        
        CATransaction.begin()
        CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({() -> Void in
            self.marker.rotation = CLLocationDegrees(getAngle * (180.0 / Float.pi));
        })
        marker.position = newLocation

        CATransaction.commit()
        
        oldLocation = newLocation
        
        
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let deltaLongitude = toLoc.longitude - fromLoc.longitude
        let deltaLatitude = toLoc.latitude - fromLoc.latitude
        
        let angle = Float.pi * 0.5 - Float(atan(deltaLatitude / deltaLongitude))
        
        if (deltaLongitude > 0)  {
            
            return angle;
            
        }else if (deltaLongitude < 0) {
            
            return angle + Float.pi
            
        }else if (deltaLatitude < 0) {
            
            return Float.pi;
            
        }
        
        return 0;
   
    }
    
  
    private func locationManager(manager: CLLocationManager!,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            NSLog("Restricted")
            //locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
           // locationStatus = "User denied access to location"
            NSLog("denied")
        case CLAuthorizationStatus.notDetermined:
            NSLog("Status")
           // locationStatus = "Status not determined"
        default:
            //locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
//        NotificationCenter.defaultCenter.postNotificationName("LabelHasbeenUpdated", object: nil)
//        if (shouldIAllow == true) {
//            NSLog("Location to Allowed")
//            // Start location services
//            locationManager.startUpdatingLocation()
//        } else {
//            //NSLog("Denied access: \(locationStatus)")
//        }
    }

    
}
