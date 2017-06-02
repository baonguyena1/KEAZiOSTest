//
//  LocationViewController.swift
//  KEAZiOSTest
//
//  Created by Bao Nguyen on 6/2/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController {
    
    fileprivate var locations = [MKPointAnnotation]()
    // Create instance of LocationService
    private let service = LocationService()
    
    // Define key for post data to server
    private enum LocationKey: CustomStringConvertible {
        case long
        case lat
        var description: String {
            switch self {
            case .long:
                return "long"
            case .lat:
                return "lat"
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapMeClicked(_ sender: UIButton) {
        postService(fromService: service)
    }
    
    private func postService<S: Postable>(fromService service: S) {
        let location: [String: Any] = [
            LocationKey.long.description: 12.545656,
            LocationKey.lat.description: 13.65657
        ]
        service.post(with: location) { (result) in
            switch result {
            case .error(let error):
                Logger.log(message: "error = \(error)", event: .e)
            case .success(let statusCode):
                Logger.log(message: "statusCode = \(statusCode)", event: .i)
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
//            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
//            mapView.showAnnotations(self.locations, animated: true)
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
    
}

