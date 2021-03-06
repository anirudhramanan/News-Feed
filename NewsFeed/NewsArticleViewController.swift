//
//  NewsArticleViewController.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 11/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class NewsArticleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var bookmarkIcon: UIBarButtonItem!
    var newsArticle: NewsArticles!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        webView.delegate = self
        url = newsArticle.url
        if let url = URL(string: (url)!) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
        if checkIfBookmarked() {
            bookmarkIcon.image = UIImage(named: "bookmark_filled")
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
    
    private func checkIfBookmarked() -> Bool {
        let realm = try! Realm()
        let bookmarkedNews = realm.objects(Bookmark.self).filter("uniqueId = %@", url).first
        return bookmarkedNews != nil
    }
    
    @IBAction func bookmarkArticle(_ sender: Any) {
        if checkIfBookmarked() {
            removeFromBookmark()
            bookmarkIcon.image = UIImage(named: "bookmark")
        } else {
            saveToBookmark()
            bookmarkIcon.image = UIImage(named: "bookmark_filled")
        }
    }
    
    private func saveToBookmark() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let realm = try! Realm()
        
        let bookmark = Bookmark()
        bookmark.date = formatter.string(from: date)
        bookmark.newsArticle = newsArticle
        bookmark.uniqueId = url
        
        try! realm.write {
            realm.add(bookmark)
        }
    }
    
    @IBAction func shareNews(_ sender: Any) {
        let text = newsArticle.title
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func removeFromBookmark() {
        let realm = try! Realm()
        let bookmarkedNews = realm.objects(Bookmark.self).filter("uniqueId = %@", url).first!
        try! realm.write {
            realm.delete(bookmarkedNews)
        }
    }
    
    private func checkInternet () {
        if !NetworkConnectivityManager.isInternetAvailable() {
            showAlertView("Internet Connectivity seems to be offline")
            indicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
}
