//
//  ActivityIndicatorHelper.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 13/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorHelper{

    static func showLoadingIndicator (view: UIView) -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = view.center
        activityView.startAnimating()
        view.addSubview(activityView)
        return activityView
    }
    
    static func stopLoadingIndicator (activityView: UIActivityIndicatorView?) {
        if activityView != nil {
            activityView?.stopAnimating()
        }
    }
}
