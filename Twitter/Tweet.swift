//
//  Tweet.swift
//  Twitter
//
//  Created by Max Pappas on 2/17/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var id: String?
    var text: String?
    var createdAtString: String?
    var createdAt: String?
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        id = String(dictionary["id"] as! Int)
        favorited = dictionary["favorited"] as? Int != 0
        retweeted = dictionary["retweeted"] as? Int != 0
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let createdAtDate = formatter.dateFromString(createdAtString!)
        createdAt = (formatter.stringFromDate(createdAtDate!) as NSString).substringWithRange(NSMakeRange(4, 6))
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
