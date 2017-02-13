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
            indicator.stopAnimating()
        } else {
            collectionView.isHidden = true
            indicator.startAnimating()
        }
    }
}
