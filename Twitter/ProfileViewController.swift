//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/27/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    var tweets: [Tweet]?
    var user: User?
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.currentUser
        }
        
        let params = ["screen_name": user!.screenname!]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        userNameLabel.text = user?.name
        screenNameLabel.text = user?.screenname
        tweetCountLabel.text = String(user!.tweetCount!)
        followingCountLabel.text = String(user!.followersCount!)
        followersCountLabel.text = String(user!.followingCount!)
        
        if user?.profileImageUrl != nil {
            avatarImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        }
        
        if user?.profileBannerUrl != nil {
            bannerImageView.setImageWithURL(NSURL(string: user!.profileBannerUrl!)!)
        }
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        
        visualEffectView.frame = bannerImageView.bounds
        
        bannerImageView.addSubview(visualEffectView)
        
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        let tweet = tweets![indexPath.row]
        let user = tweet.user!
        
        print(tweet)
        print(user)
        
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
        
        // find better way to do this
        cell.replyButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.profileButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
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
