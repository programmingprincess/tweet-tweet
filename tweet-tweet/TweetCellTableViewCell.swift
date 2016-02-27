//
//  TweetCellTableViewCell.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameHandle: UILabel!

    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favesButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    
    var tweetID: String = ""
    
    var tweet: Tweet! {
        
        didSet {
            userNameLabel.text = "\((tweet.user?.name)!)"
            userNameHandle.text = "@" + "\((tweet.user?.screenname)!)"
            tweetContent.text = tweet.text!
            //dateLabel.text = "\(tweet.createdAt!)"
            dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
            
            //Retrieving the image
            let imageUrl = NSURL(string: (tweet!.user!.profileImageUrl)!)
            print("imageUrl: \(imageUrl)")
            profilePictureImageView.setImageWithURL(imageUrl!)
            
            tweetID = tweet.id
            retweetLabel.text = String(tweet.retweetCount!)
            favoritesLabel.text = String(tweet.favoritesCount!)
            
            retweetLabel.text! == "0" ? (retweetLabel.hidden = true) : (retweetLabel.hidden = false)
            favoritesLabel.text! == "0" ? (favoritesLabel.hidden = true) : (favoritesLabel.hidden = false)
            
            
        }
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //profilePictureImageView.layer.cornerRadius = 3
        //profilePictureImageView.clipsToBounds = true

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Selected)
            
            if self.retweetLabel.text! > "0" {
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.retweetLabel.hidden = false
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
    }
    
    //The two following fuctions are curtsey of @r3dcrosse from gitHub

    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.favesButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Selected)
            
            if self.favoritesLabel.text! > "0" {
                self.favoritesLabel.text = String(self.tweet.favoritesCount! + 1)
            } else {
                self.favoritesLabel.hidden = false
                self.favoritesLabel.text = String(self.tweet.favoritesCount! + 1)
            }
        })
    }
}
    
