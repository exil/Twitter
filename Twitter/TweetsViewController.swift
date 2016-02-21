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
        
        cell.avatarView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        cell.nameLabel.text = user.name
        cell.timestampLabel.text = "4h"
        cell.usernameLabel.text = "@\(user.screenname!)"
        cell.tweetLabel.text = tweet.text
        cell.retweetLabel.text = ""
        cell.replyImageView.image = UIImage(named: "reply-action_0")
        cell.retweetImageView.image = UIImage(named: "retweet-action")
        cell.favImageView.image = UIImage(named: "like-action")
        cell.retweetCountLabel.text = String(tweet.retweetCount!)
        cell.favCountLabel.text = String(tweet.favoriteCount!)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
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
        } else if segue.identifier == "detailsSegue" {
            let cell = sender
            let indexPath = tableView.indexPathForCell(cell as! UITableViewCell)

            let tweet = tweets![indexPath!.row]
            
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            
            detailsViewController.tweet = tweet
        }
    }
    

}
