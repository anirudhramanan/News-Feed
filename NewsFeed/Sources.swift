//
//  Sources.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import RealmSwift

class Sources: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var country: String?
    dynamic var imageUrl: String?
}
