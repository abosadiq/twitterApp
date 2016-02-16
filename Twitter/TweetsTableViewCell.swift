//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/12/16.
//  Copyright © 2016 wafi. All rights reserved.
//


import UIKit

class TweetsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
   
    @IBOutlet weak var TweetContentText: UILabel!
    @IBOutlet weak var TimesCreater: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var Retweet_CountLabel: UILabel!
    @IBOutlet weak var Likes_CountLabel: UILabel!
    var tweetID: String = ""
    var tweet: Tweet! {
        didSet {
        TweetContentText.text = tweet.text
        userName.text = "\((tweet.user?.name)!)"
        userHandle.text = "@\(tweet.user!.screenname!)"
        if (tweet.user?.profileImageUrl != nil){
            let imageUrl = tweet.user?.profileImageUrl!
            profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            print("No profile image found")
        }
        Retweet_CountLabel.text = String(tweet.retweetCount!)
        Likes_CountLabel.text = String(tweet.likeCount!)
        tweetID = tweet.id
        Retweet_CountLabel.text! == "0" ? (Retweet_CountLabel.hidden = true) : (Retweet_CountLabel.hidden = false)
        Likes_CountLabel.text! == "0" ? (Likes_CountLabel.hidden = true) : (Likes_CountLabel.hidden = false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        profileImage.layer.cornerRadius = 4
       profileImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
    }
    
    
    
    @IBAction func WhenRetweeting(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
//            self.RetweetButton.setImage(UIImage(named: "Retweet.png"), forState: UIControlState.Selected)
            if self.Retweet_CountLabel.text! > "0" {
                self.Retweet_CountLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.Retweet_CountLabel.hidden = false
                self.Retweet_CountLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
    }
    
    
    
    @IBAction func WhenLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
//            self.LikeButton.setImage(UIImage(named: "Like.png"), forState: UIControlState.Selected)
            if self.Likes_CountLabel.text! > "0" {
                self.Likes_CountLabel.text = String(self.tweet.likeCount! + 1)
            } else {
                self.Likes_CountLabel.hidden = false
                self.Likes_CountLabel.text = String(self.tweet.likeCount! + 1)
            }
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
