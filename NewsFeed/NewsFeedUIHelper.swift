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
  
    func configureUI (hide: Bool) {
        if !hide {
            collectionView.isHidden = false
            ActivityIndicatorHelper.stopLoadingIndicator(activityView: self.activityView)
        } else {
            collectionView.isHidden = true
            self.activityView = ActivityIndicatorHelper.showLoadingIndicator(view: self.view)
        }
    }
}
