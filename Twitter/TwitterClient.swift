//
//  TwitterClient.swift
//  Twitter
//
//  Created by Max Pappas on 2/17/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = ""
let twitterConsumerSecret = ""
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("received")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if response != nil {
                    let user = User(dictionary: response as! NSDictionary)
                }
                
                }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            }
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if response != nil {
                    let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                    
                    for tweet in tweets {
                        print("text: \(tweet.text), created: \(tweet.createdAt)")
                    }
                }
                
                }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                    print("error getting timeline")
            }
            
            }) { (error: NSError!) -> Void in
                print("failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
}
