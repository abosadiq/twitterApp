//
//  userViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/29/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class userViewController: UIViewController {

    
    @IBOutlet weak var CountFollowers: UILabel!
    @IBOutlet weak var CountFollowing: UILabel!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var handelName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    
    var tweet: Tweet?
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImage.setImageWithURL(NSURL(string: (tweet!.user?.profileImageUrl)!)!)
      userName.text = "\((tweet!.user?.name)!)"
        handelName.text = "@\(tweet!.user!.screenname!)"
        CountFollowers.text = "\(tweet!.user!.follower!)"
       CountFollowing.text = "\(tweet!.user!.following!)"
       userText.text = tweet!.user!.tagline!
        if (tweet!.user!.profileBannerURL != nil){
            let imageUrl = tweet!.user!.profileBannerURL!
           coverImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
         CountFollowers.sizeToFit()
         CountFollowing.sizeToFit()
        
        
    }


        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
