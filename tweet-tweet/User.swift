//
//  User.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit


let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

//Hacking the currentUser class
var _currentUser: User?


class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var backgroundImageUrl: String?
    //for fun we will also include the actual dictionary
    var dictionary: NSDictionary
    var numFollowers: Int
    var numFollowing: Int
    var numTweets: Int
    
    
    init( dictionary: NSDictionary) {
        self.dictionary = dictionary

        numFollowers = (dictionary["followers_count"] as? Int)!
        numFollowing = (dictionary["friends_count"] as? Int)!
        numTweets = (dictionary["statuses_count"] as? Int)!
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
        backgroundImageUrl = dictionary["profile_banner_url"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    
    class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        //logged out or just boot up
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        let dictionary: NSDictionary?
        do {
        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
        _currentUser = User(dictionary: dictionary!)
    } catch {
        print(error)
        }
    }
}
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            } else {
                //Clear the currentUser data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
        }
    }
    
}
