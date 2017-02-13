//
//  SourceCollectionViewController.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SourceCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sources: [Sources] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        sources = NewsDataProvider.getPersistedSources()
        
        NewsDataProvider.fetchAndStoreSources({
            success in
            self.sources = NewsDataProvider.getPersistedSources()
            self.collectionView.reloadData()
        })
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sourcesFeed", for: indexPath) as! SourcesCollectionViewCell
        let source = sources[indexPath.row]
        cell.sourcesText.text = source.name
        cell.sourcesImage.image = nil
        NewsFeedClient.sharedInstance().downloadImages(url: source.imageUrl, {
            image in
            cell.sourcesImage.image = image
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
        guard let newsSource = sources[indexPath.row].id else {
            return
        }
        newViewController.newsSource = [newsSource]
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
