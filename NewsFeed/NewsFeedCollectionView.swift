//
//  NewsFeedCollectionView.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 11/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

extension NewsFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func configureNewsFeed () {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchNews(newsSource: newsSource)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(130))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsFeed", for: indexPath) as! NewsCollectionViewCell
        
        let news = newsArticles[indexPath.row + 1]
        cell.newsTitle.text = news.title
        
        if news.author != nil {
            cell.newsAuthor.text = news.author
        }
        
        NewsFeedClient.sharedInstance().downloadImages(url: news.urlToImage, {
            (error, image) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertView(error!)
                    return
                }
            }
            
            cell.newsImage.image = image
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "ShowNews":
            guard let newsArticleViewController = segue.destination as? NewsArticleViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? NewsCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            newsArticleViewController.newsArticle = newsArticles[indexPath.row + 1]
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewsHeaderView",
                                                                             for: indexPath) as! NewsCollectionReusableView
            
            if newsArticles.count > 0 {
                let newsFeed = newsArticles[indexPath.row]
                NewsFeedClient.sharedInstance().downloadImages(url: newsFeed.urlToImage, {
                    (error, image) in
                    headerView.newsImage.image = image
                })
            }
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsFeed", for: indexPath) as! NewsCollectionViewCell
        cell.newsImage.image = nil
    }
    
    private func fetchNews (newsSource: [String]) {
        for source in newsSource {
            let persistedNews = NewsDataProvider.getPersistedNews(source)
            if persistedNews.count > 1 {
                newsArticles.append(contentsOf: persistedNews)
                configureUI(hide: false)
            }
            NewsDataProvider.fetchAndStoreLiveNews(source, {
                success in
                self.configureUI(hide: false)
                self.newsArticles.append(contentsOf: NewsDataProvider.getPersistedNews(source))
                self.collectionView.reloadData()
            })
        }
    }
}
