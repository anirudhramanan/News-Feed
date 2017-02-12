//
//  NewsFeedParser.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

extension NewsFeed {
    static func parse(results: [String:AnyObject]) -> NewsFeed {
        let newsFeed: NewsFeed = NewsFeed()
        guard let status = results["status"] as? String,
            let source = results["source"] as? String,
            let sortBy = results["sortBy"] as? String,
            let articles = results["articles"] as? [[String: AnyObject]] else {
                return newsFeed
        }
        
        newsFeed.status = status
        newsFeed.source = source
        newsFeed.sortBy = sortBy
        
        for article in articles {
            let newsArticle = NewsArticles()
            guard let author = article["author"] as? String,
                let title = article["title"] as? String,
                let descrip = article["description"] as? String,
                let url = article["url"] as? String,
                let urlToImage = article["urlToImage"] as? String,
                let publishedAt = article["publishedAt"] as? String else{
                    continue
            }
            
            newsArticle.author = author
            newsArticle.title = title
            newsArticle.descrip = descrip;
            newsArticle.url = url
            newsArticle.urlToImage = urlToImage
            newsArticle.publishedAt = publishedAt
            newsFeed.articles.append(newsArticle)
        }
        
        return newsFeed
    }
}
