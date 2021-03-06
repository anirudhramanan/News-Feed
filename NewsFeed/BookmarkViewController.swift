//
//  BookmarkViewController.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    var bookmarks: [Bookmark] = []
    var label: UILabel?
    let cellHeight: Int = 150

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupBookmark()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        setupBookmark()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as! BookmarkCollectionViewCell
        let article = bookmarks[indexPath.row].newsArticle
        
        cell.newsTitle.text = article?.title
        cell.newsImage.image = nil
        NewsFeedClient.sharedInstance().downloadImages(url: article?.urlToImage, {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "ShowNews":
            guard let newsArticleViewController = segue.destination as? NewsArticleViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? BookmarkCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            newsArticleViewController.newsArticle = bookmarks[indexPath.section].newsArticle
            break
        default:
            break
        }
    }
    
    private func setupBookmark(){
        bookmarks = NewsDataProvider.getBookmarkedArticles()
        if bookmarks.count == 0 {
            collectionView.backgroundColor = UIColor.white
            emptyLabel.isHidden = false
        } else{
            emptyLabel.isHidden = true
        }
        collectionView.reloadData()
    }
}
