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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
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
            indicator.stopAnimating()
        }
    }
    
    private func fetchUpdatedNews() {
        newsArticles.removeAll()
        collectionView.backgroundColor = UIColor.white
        collectionView.reloadSections(IndexSet(integer: 0))
        collectionView.reloadData()
        
        indicator.startAnimating()
        
        for source in newsSource {
            NewsDataProvider.fetchAndStoreLiveNews(source, {
                success in
                self.newsArticles.append(contentsOf: NewsDataProvider.getPersistedNews(source))
                self.indicator.stopAnimating()
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}
