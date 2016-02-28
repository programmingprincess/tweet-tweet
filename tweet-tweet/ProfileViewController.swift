//
//  ProfileViewController.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/27/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets: [Tweet]!

    var tweet: Tweet!
    var tweetID: String = ""
    
    var meirl: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meirl = User.currentUser!
        
        nameLabel.text = meirl.name
        handleLabel.text = "@\(meirl.screenname!)"
        profilePic.setImageWithURL(NSURL(string: meirl.profileImageUrl!)!)
        backgroundPic.setImageWithURL(NSURL(string: meirl.backgroundImageUrl!)!)
        
        numTweets.text = "\(meirl.numTweets)"
        numFollowing.text = "\(meirl.numFollowing)"
        numFollowers.text = "\(meirl.numFollowers)"
        
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        
        
        /*TwitterClient.sharedInstance.userTimeline({(tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            for tweet in tweets {
                //tested: this works
                print(tweet.text)
            }
            
            self.tweetsTableView.reloadData()
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        */
        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCellTableViewCell", forIndexPath: indexPath)  as! TweetCellTableViewCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let imageUrl =  meirl.profileImageUrl!
        
        let detailViewController = segue.destinationViewController as! ProfileImageViewController
            
        detailViewController.imageUrl = imageUrl
        
        
    }
    

}
