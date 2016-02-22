//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/20/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    optional func composeViewController(ComposeViewController: ComposeViewController, didComposeTweet tweet: String)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var charCountLabel: UILabel!
    @IBOutlet var tweetButton: UIBarButtonItem!
    var replyUsername: String?
    var replyId: String?
    let maxCharCount = 140
    
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetTextView.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        
        let user = User.currentUser
        
        avatarImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        nameLabel.text = user?.name
        usernameLabel.text = user?.screenname

        self.navigationItem.rightBarButtonItem?.enabled = false
        
        if replyUsername != nil {
            tweetTextView.text = "@\(replyUsername!) "
            charCountLabel.text = String(maxCharCount - tweetTextView.text.characters.count)
        }
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTweet(sender: AnyObject) {
        let tweet = tweetTextView.text
        var params = ["status": tweet]
        
        if replyId != nil {
            params["in_reply_to_status_id"] = replyId!
        }
            
        TwitterClient.sharedInstance.composeTweetWithParams(params) { (error) -> () in
            self.delegate?.composeViewController?(self, didComposeTweet: tweet)
            self.dismissViewControllerAnimated(true) {}
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        let tweet = tweetTextView.text
        let tweetCharacterCount = tweet.characters.count
        
        charCountLabel.text = String(maxCharCount - tweetCharacterCount)
        
        if tweetCharacterCount > maxCharCount || tweetCharacterCount == 0 {
            self.navigationItem.rightBarButtonItem?.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
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
