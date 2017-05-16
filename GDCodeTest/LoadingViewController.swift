//
//  LoadingViewController.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-16.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class LoadingViewController : UIViewController, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!
    private var profiles: [Profile]!
    private var loading: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loading = false
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.activityType = .automotiveNavigation
        locationManager?.distanceFilter = 10.0  // Movement threshold for new events
        
        print("view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start updating location
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() && locationManager != nil {
            locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Close location manager
        locationManager?.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_profiles" {
            if let toViewController = segue.destination as? ProfilesViewController {
                toViewController.profiles = profiles!
            }
        }
    }
    
    // Mark: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let controller = ViewUtils.showErrorAlert(title: "", message: "")
        self.present(controller, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        do {
            let location = try Location.ofLocation(
                latitude: Double(coord.latitude),
                longitude: Double(coord.longitude))
            loadProfiles(location: location)
        } catch {
            let controller = ViewUtils.showErrorAlert(title: "", message: "")
            self.present(controller, animated: true, completion: nil)
        }
        
        locationManager?.stopUpdatingLocation()
    }
    
    // Mark: - Private methods
    private func loadProfiles(location: Location) {
        if loading {
            return
        }
        
        loading = true
        let searchRequest = SearchRequest()
        searchRequest.location = location
        
        ApiService.sharedService.getProfiles(searchRequest: searchRequest, success: { [weak self] response, responseJSONObject in
            guard let strongSelf = self else { return }
            
            strongSelf.profiles = response as? NSArray as? [Profile]
            strongSelf.performSegue(withIdentifier: "show_profiles", sender: nil)
            strongSelf.loading = false
            
        }) { [weak self] statusCode, response, error in
            guard let strongSelf = self else { return }
            
            let controller = ViewUtils.showErrorAlert(title: "", message: "")
            strongSelf.present(controller, animated: true, completion: nil)
            strongSelf.loading = false
            
        }
    }
}
