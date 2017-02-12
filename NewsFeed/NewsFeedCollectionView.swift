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
        
        newsArticles = NewsDataProvider.getPersistedNews(newsSource)
        if newsArticles.count > 0 {
            configureUI(hide: false)
        }
        
        fetchNews(newsSource: ["google-news","bbc-news", "usa-today"])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(130))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsFeed", for: indexPath) as! NewsCollectionViewCell
        
        if checkIfNewsExist(index: indexPath.section) {
            let news = newsArticles[indexPath.section].articles[indexPath.row + 1]
            cell.newsTitle.text = news.title
            
            if news.author != nil {
                cell.newsAuthor.text = news.author
            }
            
            NewsFeedClient.sharedInstance().downloadImages(url: news.urlToImage, {
                image in
                cell.newsImage.image = image
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if checkIfNewsExist(index: section) {
            return newsArticles[section].articles.count - 1
        } else {
            return 0
        }
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
            newsArticleViewController.newsArticle = newsArticles[indexPath.section].articles[indexPath.row + 1]
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
            if checkIfNewsExist(index: indexPath.section) {
                let newsFeed = newsArticles[indexPath.section].articles[0]
                headerView.newsTitle.text = newsFeed.title
                NewsFeedClient.sharedInstance().downloadImages(url: newsFeed.urlToImage, {
                    image in
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
    
    private func checkIfNewsExist(index: Int) -> Bool {
        return newsArticles.count > 0 && newsArticles[index].articles.count > 0
    }
    
    private func fetchNews (newsSource: [String]) {
        for source in newsSource {
            NewsDataProvider.fetchAndStoreLiveNews(source, {
                success in
                self.configureUI(hide: false)
                self.newsArticles = NewsDataProvider.getPersistedNews(self.newsSource)
                self.collectionView.reloadData()
            })
        }
    }
}
