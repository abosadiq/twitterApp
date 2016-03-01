//
//  DetailViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/25/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit
import DOFavoriteButton

class DetailViewController: UIViewController {
    @IBOutlet weak var likesCount1:DOFavoriteButton!
    @IBOutlet weak var userHandle: UILabel!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timeCount: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var tweetscountLabel: UILabel!
    @IBOutlet weak var tweetCount1: DOFavoriteButton!
    @IBOutlet weak var uerName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var dateFormatter = NSDateFormatter()
    var  isRetweetButton: Bool = false
    var islikeButton: Bool = false
    var LikeButton = DOFavoriteButton (frame: CGRectMake(-12, -12, 44, 45), image: UIImage(named: "like-action"))
    var TweeterButton =  DOFavoriteButton(frame: CGRectMake(-12, -12, 44, 44), image: UIImage(named: "retweet-action-pressed"))
    
    var tweet: Tweet?
    var tweetID: String = " "

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetID = tweet!.id
        print("tweetID now = \(tweetID)")
        tweetText.text = tweet? .text
        username.text = "\(tweet!.user?.name!)"
        userHandle.text = "@\(tweet!.user!.screenname!)"
        
        if (tweet!.user!.profileImageUrl != nil){
            
            let imageUrl = tweet?.user?.profileImageUrl!
            
            profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            
        }
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let dateString = dateFormatter.stringFromDate((tweet?.createdAt!)!)
        
        
        timeCount.text = "\(dateString)"
        
        
         tweetscountLabel.text = String(tweet!.retweetCount!)
       favoriteLabel.text = String(tweet!.likeCount!)
        
        tweetText.sizeToFit()


        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
        let image_view = UIImageView(frame: CGRect(x: 0, y:0, width:40, height:40))
        image_view.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "Twitter_logo")
        image_view.image = image
        self.navigationItem.titleView = image_view
        LikeButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        LikeButton.imageColorOn = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
        LikeButton.circleColor = UIColor(red: 0.4431, green: 0.1647, blue: 0.4588, alpha: 1.0) /* #712a75 */
        LikeButton.duration = 2.0
        LikeButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.likesCount1!.addSubview(LikeButton)
        
        TweeterButton.addTarget(self, action: Selector("clicked:"), forControlEvents: .TouchUpInside)
        TweeterButton.imageColorOn = UIColor(red: 0.098, green: 0.8118, blue: 0.5255, alpha: 1.0) /* #19cf86 */
        TweeterButton.duration = 2.0
        TweeterButton.circleColor = UIColor(hue: 101/360, saturation: 87/100, brightness: 45/100, alpha: 1.0) /* #2e720e */
        TweeterButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.tweetCount1!.addSubview(self.TweeterButton)
        self.tweetscountLabel.textColor = UIColor.grayColor()
        self.favoriteLabel.textColor = UIColor.grayColor()
        makingRoundedImageProfileWithRoundedBorder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                
                self.islikeButton = false
                self.tweet!.likeCount!--
                self.favoriteLabel.textColor = UIColor.grayColor()
                if self.favoriteLabel.text == "0"{
                    self.favoriteLabel.hidden = true
                }
                
                
                self.favoriteLabel.text = "\(self.tweet!.likeCount!)"
            })
            
            
            
        }else {
            
            // select with animation
            sender.select()
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet!.likeCount!++
                
                
                self.likesCount1.hidden = false
                self.favoriteLabel.textColor = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
                if self.favoriteLabel.text == "0"{
                    self.likesCount1.hidden = false
                }
                
                self.favoriteLabel.text = "\(self.tweet!.likeCount!)"
                
            })
            
            
        }
    }
    
    
    
    
    func clicked(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                self.isRetweetButton = false
                self.tweet!.retweetCount!--
                self.tweetscountLabel.textColor = UIColor.grayColor()
                if self.tweetscountLabel.text == "0"{
                    self.tweetscountLabel.hidden = true
                }
                
                
                self.tweetscountLabel.text = "\(self.tweet!.retweetCount!)"
            })
            
            
            
        }else {
            
            // select with animation
            sender.select()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet!.retweetCount!++
                
                
                self.tweetscountLabel.hidden = false
                self.tweetscountLabel.textColor = UIColor(hue: 155/360, saturation: 87/100, brightness: 81/100, alpha: 1.0) /* #19cf86 */
                if self.tweetscountLabel.text == "0"{
                    self.tweetscountLabel.hidden = false
                }
                
                self.tweetscountLabel.text = "\(self.tweet!.retweetCount!)"
                
            })
            
            
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier) == "replyFromCell" {
            
            let user = User.currentUser
            let tweet = self.tweet
            let ReplyTweetViewController = segue.destinationViewController as! ReplyingViewController
            ReplyTweetViewController.user = user
            ReplyTweetViewController.tweet = tweet
        }

         else if (segue.identifier) == "picfromCell" {
            let user = User.currentUser
            let tweet = self.tweet
            let UserProfilePageViewController = segue.destinationViewController as! userViewController
            UserProfilePageViewController.user = user
            UserProfilePageViewController.tweet = tweet
        }
        
    }

    
    
    
    
    private func makingRoundedImageProfileWithRoundedBorder() {
        // Making a circular image profile.
        //        self.myUIImageView.layer.cornerRadius = self.myUIImageView.frame.size.width / 2
        // Making a rounded image profile.
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = 30.0
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 15.0
        self.profileImage.layer.borderColor = UIColor.clearColor().CGColor
    }

   
}
