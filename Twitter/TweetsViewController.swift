//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/17/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate {

    var tweets: [Tweet]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
                    
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        let tweet = tweets![indexPath.row]
        let user = tweet.user!
        
        var retweetImage = "retweet-action"
        var favImage = "like-action"
        
        if tweet.retweeted! {
            retweetImage = "retweet-action-on"
        }
        
        if tweet.favorited! {
            favImage = "like-action-on"
        }
        
        cell.avatarView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        cell.nameLabel.text = user.name
        cell.timestampLabel.text = tweet.createdAt
        cell.usernameLabel.text = "@\(user.screenname!)"
        cell.tweetLabel.text = tweet.text
        cell.retweetLabel.text = ""
        cell.replyImageView.image = UIImage(named: "reply-action_0")
        cell.retweetImageView.image = UIImage(named: retweetImage)
        cell.favImageView.image = UIImage(named: favImage)
        cell.retweetCountLabel.text = String(tweet.retweetCount!)
        cell.favCountLabel.text = String(tweet.favoriteCount!)
        cell.replyButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
    }

    @IBAction func onRetweet(sender: AnyObject) {
        if sender.tag != nil {
            let tweet = tweets![sender.tag]
            let params = ["id": tweet.id!]

            TwitterClient.sharedInstance.retweetTweetWithParams(params) { (error) -> () in
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! TweetCell
                
                cell.retweetCountLabel.text = String(Int(cell.retweetCountLabel.text!)! + 1)
                cell.retweetImageView.image = UIImage(named: "retweet-action-on")
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if sender.tag != nil {
            let tweet = tweets![sender.tag]
            let params = ["id": tweet.id!]
            
            TwitterClient.sharedInstance.favoriteTweetWithParams(params) { (error) -> () in
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! TweetCell
                
                cell.favCountLabel.text = String(Int(cell.favCountLabel.text!)! + 1)
                cell.favImageView.image = UIImage(named: "like-action-on")
            }
        }
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func composeViewController(composeViewController: ComposeViewController, didComposeTweet tweet: String) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "composeSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
        
            composeViewController.delegate = self
        } else if segue.identifier == "composeWithReplySegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            
            if sender!.tag != nil {
                let tweet = tweets![sender!.tag]
                print(tweet)
                composeViewController.replyUsername = tweet.user!.screenname
                composeViewController.replyId = tweet.id
            }
            
            composeViewController.delegate = self
        } else if segue.identifier == "detailsSegue" {
            let cell = sender
            let indexPath = tableView.indexPathForCell(cell as! UITableViewCell)

            let tweet = tweets![indexPath!.row]
            
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            
            detailsViewController.tweet = tweet
        }
    }
    

}
