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
    
    // Create instance of LocationService
    fileprivate let service = LocationService()
    
    // Define key for post data to server
    fileprivate enum LocationKey: CustomStringConvertible {
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
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        locationManager.startUpdatingLocation()
    }
    
    // Call LocationService
    fileprivate func postService<S: Postable>(fromService service: S, with location: [String: Any]) {
        Logger.log(message: "post new location = \(location)", event: .i)
        service.post(with: location) { (result) in
            switch result {
            case .error(let error):
                Logger.log(message: "error = \(error)", event: .e)
            case .success(let statusCode):
                Logger.log(message: "statusCode = \(statusCode)", event: .i)
            }
        }
    }
    
    //MARK: - Handler timer for save power, update location every 1 minutes
    fileprivate func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1 * 60, target: self, selector: #selector(startUpdatingLocation), userInfo: nil, repeats: true)
    }
    
    fileprivate func stopTimer() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        startTimer()
    }
    
    @objc private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopTimer()
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let location: [String: Any] = [
            LocationKey.long.description: mostRecentLocation.coordinate.longitude,
            LocationKey.lat.description: mostRecentLocation.coordinate.longitude
        ]
        
        postService(fromService: service, with: location)
        
        if UIApplication.shared.applicationState == .active {

        } else {
            Logger.log(message: "App is backgrounded. New location is \(mostRecentLocation)", event: .i)
        }
    }
    
}

