//
//  NewsFeed.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 10/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import RealmSwift

class NewsFeed: Object {
    dynamic var status: String?
    dynamic var source: String?
    dynamic var sortBy: String?
    var articles = List<NewsArticles>()
}
