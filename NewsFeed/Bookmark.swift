//
//  Bookmark.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    dynamic var newsArticle: NewsArticles?
    dynamic var date: String?
    dynamic var uniqueId: String?
}
