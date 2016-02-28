//
//  TwitterClient.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "FnnLY3dGtAjT805JZHNegU3a6", consumerSecret: "3NgzPkfn3BneD6Vj9uPk16tT1b9B3Z1O9bkoovUdd83Rf8WRg3")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            //logged in here!
            
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                
                }, failure: { (error: NSError) -> () in
                    print("error: \(error.localizedDescription)")
                    self.loginFailure?(error)
                    
            })
            
            
            self.loginSuccess?()
            }) {
                (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
                
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: NSError ->() ) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {( task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            //tweets are an array of NSDict
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            
            //for tweet in tweets {
            //    print("\(tweet.text!)")
            //}
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    }
    
    
    func userTimeline(success: ([Tweet]) -> (), failure: NSError ->() ) {
        GET("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: {( task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            //tweets are an array of NSDict
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            //for tweet in tweets {
            //    print("\(tweet.text!)")
            //}
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func composeMe(status: String, success: () -> (), failure: (NSError) -> () ) {
        POST("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: {( task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            success()

            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }

    

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
           // print("name: \(user.name)")
           // print("username: \(user.screename)")
           // print("profile url: \(user.profileUrl)")
            //print("description: \(user.tagline)")
            
            }, failure: {( task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    }
    
    func login(success: () -> (), failure: (NSError) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        //logout first; clear previous sessions
        TwitterClient.sharedInstance.deauthorize()
        
        //request token to verify app
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            })
            { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    } //end of login
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    //retweet and like
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                completion(error: error)
            }
        )
    }
    
    func likeTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't like tweet")
                completion(error: error)
            }
        )}

}
