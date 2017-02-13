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
    var newsArticles: [NewsArticles] = []
    var newsSource: [String] = ["google-news","bbc-news", "usa-today"]
    let cellHeight: Int = 130
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(hide: true)
        configureNewsFeed()
    }
    
    @IBAction func refreshNews(_ sender: Any) {
        if NetworkConnectivityManager.isInternetAvailable() {
            fetchUpdatedNews()
        } else{
            showAlertView("Internet Connectivity seems to be offline")
        }
    }
    
    private func fetchUpdatedNews() {
        newsArticles.removeAll()
        collectionView.reloadSections(IndexSet(integer: 0))
        collectionView.reloadData()
        
        let activityIndicator = ActivityIndicatorHelper.showLoadingIndicator(view: self.view)
        for source in newsSource {
            NewsDataProvider.fetchAndStoreLiveNews(source, {
                success in
                self.newsArticles.append(contentsOf: NewsDataProvider.getPersistedNews(source))
                self.collectionView.reloadData()
                ActivityIndicatorHelper.stopLoadingIndicator(activityView: activityIndicator)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
