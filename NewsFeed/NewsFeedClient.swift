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
    
    func fetchNewsFromNetwork(_ source: String, _ completionHandler: @escaping(_ error: String?, _ newsFeed: NewsFeed?) -> Void) {
        
        let url: String = APIConstant.NEWS_ARTICLE_HOST  + source + "&apiKey=" + APIConstant.API_KEY
        
        Alamofire.request(url).responseJSON { response in
            if let error = response.error {
                completionHandler(error.localizedDescription, nil)
                return
            }
            
            guard let JSON = response.result.value else {
                return
            }
            
            let newsFeed = NewsFeed.parse(results: JSON as! [String : AnyObject])
            completionHandler(nil, newsFeed)
        }
    }
    
    func fetchSourcesFromNetwork(_ completionHandler: @escaping(_ error: String?, _ sources: [Sources]?) -> Void) {
        let url: String = APIConstant.NEWS_SOURCE_HOST
        
        Alamofire.request(url).responseJSON { response in
            
            if let error = response.error {
                completionHandler(error.localizedDescription, nil)
                return
            }
            
            guard let JSON = response.result.value else {
                return
            }
            
            let sources = Sources.parse(results: JSON as! [String : AnyObject])
            completionHandler(nil, sources)
        }
    }
    
    func downloadImages(url: String!, _ completionHandler: @escaping(_ error: String?, _ image: UIImage?) -> Void) {
        
        guard let url = url else {
            return
        }
        
        Alamofire.request(url).responseImage { response in
        
            if let error = response.error {
                completionHandler(error.localizedDescription, nil)
                return
            }
            
            guard let value = response.result.value else{
                return
            }
            
            completionHandler(nil, value)
        }
    }
    
    class func sharedInstance() -> NewsFeedClient {
        struct Singleton {
            static var sharedInstance = NewsFeedClient()
        }
        return Singleton.sharedInstance
    }
}
