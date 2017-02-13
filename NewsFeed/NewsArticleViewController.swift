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
        indicator.isHidden = true
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
    
    private func removeFromBookmark() {
        let realm = try! Realm()
        let bookmarkedNews = realm.objects(Bookmark.self).filter("uniqueId = %@", url).first!
        try! realm.write {
            realm.delete(bookmarkedNews)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
}
