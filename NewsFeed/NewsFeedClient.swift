//
//  NewsFeedClient.swift
//  NewsFeed
//
//  Created by Anirudh Ramanan on 10/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RealmSwift

class NewsFeedClient {
    
    func fetchNewsFromNetwork(_ source: String, _ completionHandler: @escaping(_ newsFeed: NewsFeed) -> Void) {
        
        let url: String = "https://newsapi.org/v1/articles?source="  + source + "&apiKey=77aed9f1b26645069c13e6019841fcae"
        
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else {
                return
            }
            
            let newsFeed = NewsFeed.parse(results: JSON as! [String : AnyObject])
            completionHandler(newsFeed)
        }
    }
    
    func fetchSourcesFromNetwork(_ completionHandler: @escaping(_ sources: [Sources]) -> Void) {
        let url: String = "https://newsapi.org/v1/sources?language=en"
        
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else {
                return
            }
            
            let sources = Sources.parse(results: JSON as! [String : AnyObject])
            completionHandler(sources)
        }
    }
    
    func downloadImages(url: String!, _ completionHandler: @escaping(_ image: UIImage) -> Void) {
        
        Alamofire.request(url).responseImage { response in
            completionHandler(response.result.value!)
        }
    }
    
    class func sharedInstance() -> NewsFeedClient {
        struct Singleton {
            static var sharedInstance = NewsFeedClient()
        }
        return Singleton.sharedInstance
    }
}
