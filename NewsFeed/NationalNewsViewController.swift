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
    
    private var locationManager: CLLocationManager!
    private var activityView: UIActivityIndicatorView!
    var sources: [Sources] = []
    private var didPerformGeocode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = ActivityIndicatorHelper.showLoadingIndicator(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLocationManager()
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
                    
                    var newsSources: [String] = []
                    for source in self.sources {
                        if !newsSources.contains(source.id!) {
                            newsSources.append(source.id!)
                        }
                    }
                    
                    controller.newsSource = newsSources
                    DispatchQueue.main.async {
                        ActivityIndicatorHelper.stopLoadingIndicator(activityView: self.activityView)
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
    
    private func configureLocationManager () {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
