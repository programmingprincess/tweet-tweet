//
//  ProfileImageViewController.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/27/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileImageViewController: UIViewController {
    
    @IBOutlet weak var bigProfilePic: UIImageView!
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigProfilePic.setImageWithURL(NSURL(string: imageUrl!)!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
