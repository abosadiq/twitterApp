//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/12/16.
//  Copyright © 2016 wafi. All rights reserved.
//


import UIKit
import DOFavoriteButton

class TweetsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
   
    @IBOutlet weak var TweetContentText: UILabel!
    @IBOutlet weak var TimesCreater: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var LikeButton: DOFavoriteButton!
    @IBOutlet weak var Retweet_CountLabel: UILabel!
    @IBOutlet weak var Likes_CountLabel: UILabel!
//   var button = DOFavoriteButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "star"))
    var  isRetweetButton: Bool = false
    var islikeButton: Bool = false
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
            self.Likes_CountLabel.textColor = UIColor.grayColor()
            self.Retweet_CountLabel.textColor = UIColor.grayColor()
            

         }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        profileImage.layer.cornerRadius = 4
       profileImage.clipsToBounds = true
        userName.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        //weetContentText.preferredMaxLayoutWidth = TweetContentText.frame.size.height
    }
    
    @IBAction func OnTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
            
            if self.isRetweetButton {
        self.Retweet_CountLabel.text = String(self.tweet.retweetCount!) 
        self.RetweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: UIControlState.Normal)
            self.isRetweetButton = false
            self.tweet.retweetCount!--
           self.Retweet_CountLabel.textColor = UIColor.grayColor()
            if self.Retweet_CountLabel.text == "0"{
                self.Retweet_CountLabel.hidden = true
                }
        } else{
            self.RetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
        
            self.Retweet_CountLabel.textColor = UIColor(red: 0.0157, green: 0.9176, blue:0.5137, alpha: 1.0)
            self.isRetweetButton = true
            self.tweet.retweetCount!++
                if self.Retweet_CountLabel.text == "0"{
                    self.Retweet_CountLabel.hidden = false
                }

                
            }
        self.Retweet_CountLabel.text = "\(self.tweet.retweetCount!)"
        })
    }
    @IBAction func OnLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in

         if self.islikeButton {
      self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
            self.islikeButton = false
            self.tweet.likeCount!--
            self.Likes_CountLabel.textColor = UIColor.grayColor()
            if self.Likes_CountLabel.text == "0"{
                self.Likes_CountLabel.hidden = true
             }
           }
        else{
            self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
            self.islikeButton = true
            self.tweet.likeCount!++
            self.Likes_CountLabel.hidden = false
            self.Likes_CountLabel.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0) /* #d82934 */
            if self.Likes_CountLabel.text == "0"{
                self.Likes_CountLabel.hidden = false
          }
            }
           
           self.Likes_CountLabel.text = "\(self.tweet.likeCount!)"
            })
    }
    
    
    
   override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
}
