//
//  TweetCell.swift
//  Twitter
//
//  Created by Max Pappas on 2/19/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var replyImageView: UIImageView!
    @IBOutlet var favImageView: UIImageView!
    @IBOutlet var retweetImageView: UIImageView!
    @IBOutlet var favCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var profileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
