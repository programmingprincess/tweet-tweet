//
//  TweetsViewController.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/20/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimeline({(tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text)
            }
            self.tableView.reloadData()
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
      
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCellTableViewCell", forIndexPath: indexPath)  as! TweetCellTableViewCell
        cell.tweet = tweets![indexPath.row]

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
        
            let tweet = tweets![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailedTweetsViewController
        
            detailViewController.tweet = tweet
        }
    }


}
