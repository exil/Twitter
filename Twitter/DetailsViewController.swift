//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/20/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, ComposeViewControllerDelegate {
    
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
    @IBOutlet var timestampLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet!.user!
        
        print(tweet)
        avatarImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        nameLabel.text = user.name
        timestampLabel.text = tweet!.createdAt
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

    @IBAction func onFavorite(sender: AnyObject) {
        let params = ["id": tweet!.id!]
        
        TwitterClient.sharedInstance.favoriteTweetWithParams(params) { (error) -> () in
            self.retweetCountLabel.text = String(Int(self.favCountLabel.text!)! + 1)
            self.favImageView.image = UIImage(named: "like-action-on")
        }
        
    }
    @IBAction func onRetweet(sender: AnyObject) {
        let params = ["id": tweet!.id!]
        
        TwitterClient.sharedInstance.retweetTweetWithParams(params) { (error) -> () in
            self.retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! + 1)
            self.retweetImageView.image = UIImage(named: "retweet-action-on")
        }
    }
    @IBAction func onReply(sender: AnyObject) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let composeViewController = navigationController.topViewController as! ComposeViewController

        composeViewController.replyUsername = tweet!.user!.screenname
        composeViewController.replyId = tweet!.id
        
        composeViewController.delegate = self
    }


}
