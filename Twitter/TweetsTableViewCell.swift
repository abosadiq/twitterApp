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
    @IBOutlet weak var RetweetButton:  DOFavoriteButton!
    @IBOutlet weak var Retweet_CountLabel: UILabel!
    @IBOutlet weak var Likes_CountLabel: UILabel!
   var LikeButton = DOFavoriteButton(frame: CGRectMake(-12, -12, 42, 42), image: UIImage(named: "like-action"))
    var TweeterButton =  DOFavoriteButton(frame: CGRectMake(-9, -9, 42, 42), image: UIImage(named: "retweet-action-pressed"))


    @IBOutlet weak var LikeButtonView: UIView!
    
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
            self.Likes_CountLabel.textColor = UIColor.grayColor()
            self.Retweet_CountLabel.textColor = UIColor.grayColor()

        Retweet_CountLabel.text! == "0" ? (Retweet_CountLabel.hidden = true) : (Retweet_CountLabel.hidden = false)
        Likes_CountLabel.text! == "0" ? (Likes_CountLabel.hidden = true) : (Likes_CountLabel.hidden = false)
            LikeButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
            LikeButton.imageColorOn = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
            LikeButton.circleColor = UIColor(red: 0.4431, green: 0.1647, blue: 0.4588, alpha: 1.0) /* #712a75 */
            LikeButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
             //LikeButton.addTarget(self, action: Selector("tappedButton:"), forControlEvents: UIControlEvents.TouchUpInside)
          LikeButton.duration = 3.0 // default: 1.0

           self.LikeButtonView!.addSubview(LikeButton)
            TweeterButton.addTarget(self, action: Selector("clicked:"), forControlEvents: .TouchUpInside)
            TweeterButton.imageColorOn = UIColor(red: 0.098, green: 0.8118, blue: 0.5255, alpha: 1.0) /* #19cf86 */
            TweeterButton.duration = 2.0
            TweeterButton.circleColor = UIColor(hue: 101/360, saturation: 87/100, brightness: 45/100, alpha: 1.0) /* #2e720e */
            TweeterButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
            self.RetweetButton.addSubview(self.TweeterButton)
             makingRoundedImageProfileWithRoundedBorder()
          
         }
        
    }
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            
            
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                    //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                    self.islikeButton = false
                    self.tweet.likeCount!--
                    self.Likes_CountLabel.textColor = UIColor.grayColor()
                    if self.Likes_CountLabel.text == "0"{
                        self.Likes_CountLabel.hidden = true
                    }

                
                self.Likes_CountLabel.text = "\(self.tweet.likeCount!)"
            })
            
        } else {
            
            // select with animation
            sender.select()
            
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
              
                    // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                    self.islikeButton = true
              
                    self.tweet.likeCount!++
            

                    self.Likes_CountLabel.hidden = false
                    self.Likes_CountLabel.textColor = UIColor(red: 0.9098, green: 0.1098, blue: 0.3098, alpha: 1.0) /* #e81c4f */
                    if self.Likes_CountLabel.text == "0"{
                        self.Likes_CountLabel.hidden = false
                    }
                    self.Likes_CountLabel.text = "\(self.tweet.likeCount!)"

                })

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
    func clicked(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                self.isRetweetButton = false
                self.tweet.retweetCount!--
                self.Retweet_CountLabel.textColor = UIColor.grayColor()
                if self.Retweet_CountLabel.text == "0"{
                    self.Retweet_CountLabel.hidden = true
                }
                
                
                self.Retweet_CountLabel.text = "\(self.tweet.retweetCount!)"
            })
            
            
        } else {
            
            // select with animation
            sender.select()
            
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet.retweetCount!++
                
                
                self.Retweet_CountLabel.hidden = false
                self.Retweet_CountLabel.textColor = UIColor(hue: 155/360, saturation: 87/100, brightness: 81/100, alpha: 1.0) /* #19cf86 */
                if self.Retweet_CountLabel.text == "0"{
                    self.Retweet_CountLabel.hidden = false
                }
                
                self.Retweet_CountLabel.text = "\(self.tweet.retweetCount!)"
                
            })
            
            
            
        }
       
        
    }
    

    
    
   override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    private func makingRoundedImageProfileWithRoundedBorder() {
        // Making a circular image profile.
        //        self.myUIImageView.layer.cornerRadius = self.myUIImageView.frame.size.width / 2
        // Making a rounded image profile.
        self.profileImage.layer.cornerRadius = 25.0
        
        self.profileImage.clipsToBounds = true
        
        // Adding a border to the image profile
        self.profileImage.layer.borderWidth = 15.0
        self.profileImage.layer.borderColor = UIColor.clearColor().CGColor
    }

    
}
