//
//  TweetCellTableViewCell.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favesLabel: UILabel!
    
    @IBOutlet weak var rtButton: UIButton!
    
    @IBOutlet weak var favesButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    
    /*
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    */
    var didRetweet = false
    var didTouchFavourite = false
    
    var tweetId: Int!
    
    var tweet: Tweet! {
        didSet {
            tweetId = tweet.id
            let url = NSURL( string: ( tweet.user?.profileImageUrl!)! )
            print(url!)
            profileImage.setImageWithURL(url!)
            screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            nameLabel.text = tweet.user?.name
            tweetContent.text = tweet.text
            RTcount.text = String(tweet.retweetCount!)
            favesLabel.text = String(tweet.favouriteCount!)
            dateLabel.text = durationString(tweet.createdAt!)
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        print("onReply clicked")
        //TODO: create a reply feature
    }
    
    @available(iOS, deprecated=8.0)
    @IBAction func onRetweet(sender: AnyObject) {
        if !didRetweet {
            //perform retweet logics
            TwitterClient.sharedInstance.retweetStatus(tweetId) { error in
                self.tweet.retweetCount! += 1
                self.retweetButton.setImage(UIImage(named: "RetweetIconOn"), forState: .Normal)
                self.retweetCountLabel.text = "\(self.tweet.retweetCount!)"
                self.didRetweet = true
            }
        } else {
            //un retweet, if successful, decrement
            TwitterClient.sharedInstance.unretweetStatus(tweetId) { error in
                
            }
        }
    }
    
    func durationString(createdAt: NSDate?) -> String {
        let durationAgo = (moment() - moment(createdAt!))
        if durationAgo.hours >= 24 {
            return "\(Int(durationAgo.days))d"
        } else if durationAgo.minutes >= 60 {
            return "\(Int(durationAgo.hours))h"
        } else if durationAgo.seconds >= 60 {
            return "\(Int(durationAgo.minutes))m"
        } else {
            return "1m"
        }
    }
    
    @available(iOS, deprecated=8.0)
    @IBAction func onFavourite(sender: AnyObject) {
        
        if !didTouchFavourite {
            //call favourite
            TwitterClient.sharedInstance.favoriteStatus(tweetId) { errror in
                self.didTouchFavourite = true
                self.tweet.favouriteCount! += 1
                self.favouriteButton.setImage(UIImage(named: "LikeIconOn"), forState: .Normal)
                self.favouriteCountLabel.text = "\(self.tweet.favouriteCount!)"
            }
        } else {
            //call unfavouriteStatus
            TwitterClient.sharedInstance.unfavoriteStatus(tweetId) { error in
                self.didTouchFavourite = false
                self.tweet.favouriteCount! -= 1
                self.favouriteButton.setImage(UIImage(named: "LikeIcon"), forState: .Normal)
                self.favouriteCountLabel.text = "\(self.tweet.favouriteCount!)"
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set tweetId
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
