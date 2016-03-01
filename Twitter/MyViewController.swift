//
//  MyViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/28/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var etting: UIButton!
    @IBOutlet weak var onLogout: UIButton!
       @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var myprifileImage: UIImageView!
    
    var tweets: [Tweet]?
    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       myprifileImage.setImageWithURL(NSURL(string: (User.currentUser!.profileImageUrl)!)!)
        userName.text = "\((User.currentUser!.name)!)"
        userHandle.text = "@\(User.currentUser!.screenname!)"
        followersCount.text = "\(User.currentUser!.follower!)"
       followingCount.text = "\(User.currentUser!.following!)"
       textLabel.text = User.currentUser!.tagline!
        if (User.currentUser!.profileBannerURL != nil){
            let imageUrl = User.currentUser!.profileBannerURL!
            coverImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        

        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("singOut"));
           self.onLogout.userInteractionEnabled = true;
            self.onLogout.addGestureRecognizer(tapGestureRecognizer);
            

        }
          userHandle.sizeToFit()
        makingRoundedImageProfileWithRoundedBorder()
        // Do any additional setup after loading the view.
        let image_view = UIImageView(frame: CGRect(x: 0, y:0, width:40, height:40))
        image_view.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "makefg")
        image_view.image = image
        self.navigationItem.titleView = image_view
        UIApplication.sharedApplication().statusBarStyle = .Default;
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.navigationController!.navigationBar.translucent = false
        //self.navigationController!.navigationBar.tintColor = UIColor.blueColor()                 }
        //self.navigationItem.title = "Twitter"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController!.navigationBar.tintColor = UIColor.redColor()

        
        
        

    }
    
    
    @IBAction func onImageChange(sender: AnyObject) {
        let picker_2 = UIImagePickerController()
        
        picker_2.delegate = self
        picker_2.sourceType = .Camera
        
        presentViewController(picker_2, animated: true, completion: nil)
        
        

    }
    
    @IBAction func onEtting(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        coverImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController_2(picker_2: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        coverImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    func singOut() {
        let actionController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet);
        
        let cancel_Action_Button: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionController.addAction(cancel_Action_Button)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Sign Out", style: .Destructive)
            { action -> Void in
            
        }
        actionController.addAction(deleteActionButton)
        
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func makingRoundedImageProfileWithRoundedBorder() {
        // Making a circular image profile.
        //        self.myUIImageView.layer.cornerRadius = self.myUIImageView.frame.size.width / 2
        // Making a rounded image profile.
        self.myprifileImage.layer.cornerRadius = 25.0
        
        self.myprifileImage.clipsToBounds = true
        
        // Adding a border to the image profile
        self.myprifileImage.layer.borderWidth = 15.0
        self.myprifileImage.layer.borderColor = UIColor.clearColor().CGColor
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
