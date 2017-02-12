//
//  NewsArticles.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 10/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import RealmSwift

class NewsArticles: Object {
    dynamic var author: String?
    dynamic var title: String?
    dynamic var descrip: String?
    dynamic var url: String?
    dynamic var urlToImage: String?
    dynamic var publishedAt: String?
    dynamic var image: NSData?
}
