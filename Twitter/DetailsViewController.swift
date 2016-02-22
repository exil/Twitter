//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/20/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var tweet: Tweet?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var favCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favImageView: UIImageView!
    @IBOutlet var retweetImageView: UIImageView!
    @IBOutlet var replyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet!.user!
        
        print(tweet)
        avatarImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        nameLabel.text = user.name
        //timestampLabel.text = "4h"
        usernameLabel.text = "@\(user.screenname!)"
        tweetLabel.text = tweet!.text
        retweetLabel.text = ""
        
        replyImageView.image = UIImage(named: "reply-action_0")
        retweetImageView.image = UIImage(named: "retweet-action")
        favImageView.image = UIImage(named: "like-action")
        retweetCountLabel.text = String(tweet!.retweetCount!)
        favCountLabel.text = String(tweet!.favoriteCount!)
        //replyButton.tag = indexPath.row

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
