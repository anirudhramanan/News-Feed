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
        for source in newsSource {
            NewsDataProvider.fetchAndStoreLiveNews(source, {
                success in
                self.newsArticles.removeAll()
                self.newsArticles.append(contentsOf: NewsDataProvider.getPersistedNews(source))
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
