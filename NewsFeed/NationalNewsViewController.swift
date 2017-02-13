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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            if let error = error {
                self.showAlertView(error.localizedDescription)
                self.activityView.stopAnimating()
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
                        self.activityIndicator.stopAnimating()
                        self.view.addSubview(controller.view)
                        self.addChildViewController(controller)
                        controller.didMove(toParentViewController: self)
                    }
                })
            } else {
                self.showAlertView("Problem with the data received from geocoder")
                self.activityView.stopAnimating()
            }
        })
    }
    
    private func configureLocationManager () {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
