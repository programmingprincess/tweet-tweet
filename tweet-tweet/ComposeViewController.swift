//
//  ComposeViewController.swift
//  tweet-tweet
//
//  Created by Jiaqi Wu on 2/27/16.
//  Copyright © 2016 Jiaqi Wu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        
    TwitterClient.sharedInstance.composeMe(textArea.text, success: { () -> () in
            print("successfully tweeted")
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
