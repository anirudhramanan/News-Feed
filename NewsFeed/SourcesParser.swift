//
//  SourcesParser.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 12/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

extension Sources {
    
    static func parse(results: [String:AnyObject]) -> [Sources] {
        var sources: [Sources] = []
        
        guard let newsSources = results["sources"] as? [[String: AnyObject]] else {
            return sources
        }
        
        for s in newsSources {
            guard let id =  s["id"] as? String,
                let country =  s["country"] as? String,
                let name =  s["name"] as? String else {
                    continue
            }
            
            let urlToLogs = s["urlsToLogos"] as! [String: AnyObject]
            
            let source: Sources = Sources()
            source.id = id
            source.name = name
            source.country = country
            source.imageUrl = urlToLogs["medium"] as! String?
            sources.append(source)
        }
        
        return sources
    }
}
