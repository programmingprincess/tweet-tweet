//
//  DetailedTweetsViewController.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/27/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit
import AFNetworking

class DetailedTweetsViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    //static labels
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    var tweet: Tweet!
    var tweetID: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\((tweet.user?.name)!)"
        handleLabel.text = "@" + "\((tweet.user?.screenname)!)"
        tweetContent.text = tweet.text!
        //dateLabel.text = "\(tweet.createdAt!)"
        dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
                
        //Retrieving the image
        let imageUrl = NSURL(string: (tweet!.user!.profileImageUrl)!)
                
        profilePic.setImageWithURL(imageUrl!)
                
        tweetID = tweet.id
        numRetweets.text = String(tweet.retweetCount!)
        numLikes.text = String(tweet.favoritesCount!)
                
        numRetweets.text! == "0" ? (numRetweets.hidden = true) : (numRetweets.hidden = false)
        numLikes.text! == "0" ? (numLikes.hidden = true) : (numLikes.hidden = false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This function is courtsey of @r3dcrosse
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
