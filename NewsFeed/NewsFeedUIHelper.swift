//
//  NewsFeedActivityIndicatorHelper.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 11/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

extension NewsFeedViewController {
    
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
    
    func configureUI (hide: Bool) {
        if !hide {
            collectionView.isHidden = false
            stopLoadingIndicator()
        } else {
            collectionView.isHidden = true
            showLoadingIndicator()
        }
    }
}
