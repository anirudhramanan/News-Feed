//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 10/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var activityView: UIActivityIndicatorView!
    var newsArticles: [NewsFeed]!
    var newsSource: String = "google-news"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(hide: true)
        configureNewsFeed()
    }
    
    @IBAction func refreshNews(_ sender: Any) {
        NewsDataProvider.fetchAndStoreLiveNews(newsSource, {
            success in
            self.newsArticles = NewsDataProvider.getPersistedNews(self.newsSource)
            self.collectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
