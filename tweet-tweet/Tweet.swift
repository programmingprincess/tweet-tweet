//
//  Tweet.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var timestamp: NSDate?
    
    var id: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    
    init(dictionary:NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
            
        text = dictionary["text"] as? String
        //use if exists, otherwise use 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.dateFromString(timeStampString)
        }
        
        id = String(dictionary["id"]!)
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        
        for dictionary in dictionaries {
            //create a dictionary for each tweet 
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}


