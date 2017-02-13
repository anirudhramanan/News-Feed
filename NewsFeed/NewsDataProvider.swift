//
//  NewsDataProvider.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 11/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class NewsDataProvider {
    
    static func fetchAndStoreLiveNews (_ source: String, _ responseReceived: @escaping(_ success: Bool) -> Void) {
        let realm = try! Realm()
    
        NewsFeedClient.sharedInstance().fetchNewsFromNetwork(source, {
            (error, newsFeed) in
            
            if error != nil {
                responseReceived(false)
                return
            }
            
            let newsFeedStore = NewsFeed()
            newsFeedStore.source = source
            
            for article in (newsFeed?.articles)! {
                newsFeedStore.articles.append(article)
            }
            
            try! realm.write {
                realm.add(newsFeedStore)
            }
        
            responseReceived(true)
        })
    }
    
    static func fetchAndStoreSources (_ responseReceived: @escaping(_ success: Bool) -> Void) {
        let realm = try! Realm()
        
        NewsFeedClient.sharedInstance().fetchSourcesFromNetwork({
            (error, sources) in
            
            if error != nil {
                responseReceived(false)
                return
            }
            
            for source in sources! {
                if realm.objects(Sources.self).filter("id = %@", source.id!).count == 0 {
                    try! realm.write {
                        realm.add(source)
                    }
                }
            }
            
            responseReceived(true)
        })
    }
    
    static func getPersistedNews (_ source: String)  -> [NewsArticles] {
        let realm = try! Realm()
        let newsFeedStored = realm.objects(NewsFeed.self).filter("source = %@", source).first
        guard let articles = newsFeedStored?.articles else {
            return [NewsArticles()]
        }
        var newsArray: [NewsArticles] = Array(articles)
        newsArray = newsArray.reversed()
        return newsArray
    }
    
    static func getPersistedSources ()  -> [Sources] {
        let realm = try! Realm()
        let newsFeedStored = realm.objects(Sources.self)
        var newsArray: [Sources] = Array(newsFeedStored)
        newsArray = newsArray.reversed()
        return newsArray
    }

    static func getPersistedSourcesCountryWise (country: String)  -> [Sources] {
        let realm = try! Realm()
        let newsFeedStored = realm.objects(Sources.self).filter("country = %@", country)
        let newsArray: [Sources] = Array(newsFeedStored)
        return newsArray
    }
    
    static func getBookmarkedArticles() -> [Bookmark] {
        let realm = try! Realm()
        let bookmarks = realm.objects(Bookmark.self)
        var bookmarksArray: [Bookmark] = Array(bookmarks)
        bookmarksArray = bookmarksArray.reversed()
        return bookmarksArray
    }
}
