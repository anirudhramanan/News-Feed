//
//  NationalNewsViewController.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import CoreLocation

class NationalNewsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var activityView: UIActivityIndicatorView!
    var sources: [Sources] = []
    private var didPerformGeocode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard !didPerformGeocode else { return }
        didPerformGeocode = true
        self.locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks?.count != 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                NewsDataProvider.fetchAndStoreSources({
                    success in
                    self.sources = NewsDataProvider.getPersistedSourcesCountryWise(country: (pm.isoCountryCode?.lowercased())!)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
                    controller.newsSource = [self.sources[0].id!]
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                        self.view.addSubview(controller.view)
                        self.addChildViewController(controller)
                        controller.didMove(toParentViewController: self)
                    }
                })
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func showLoadingIndicator () {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    func stopLoadingIndicator () {
        if activityView != nil {
            activityView.stopAnimating()
        }
    }
}
