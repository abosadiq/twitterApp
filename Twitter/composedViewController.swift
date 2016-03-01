//
//  composedViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/29/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class composedViewController: UIViewController, UITextViewDelegate {
  
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var initialText: UILabel!
    @IBOutlet weak var text_view: UITextView!
    @IBOutlet weak var CountsLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var hadleName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
   // @IBOutlet weak var initialText: UITextField!
    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!

    
    var placeHolderText = "Placeholder Text..."
    override func viewDidLoad() {
        super.viewDidLoad()
         text_view.delegate = self
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
            profileImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        userName.text = "\((user?.name)!)"
        hadleName.text = "@\(user!.screenname!)"
        text_view.delegate = self
        CountsLabel.text = "140"
      initialText.text = "Tweet Here ...."
     initialText.sizeToFit()
       text_view.addSubview(initialText)
      initialText.hidden = !text_view.text.isEmpty
        text_view.becomeFirstResponder()
       tweetButton.enabled = false
        makingRoundedImageProfileWithRoundedBorder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        print("cancel")
    
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        tweetMessage = text_view.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        TwitterClient.sharedInstance.ComposeTweet(TweetMessage!, params: nil, completion: { (error) -> () in
            print(error)
        })
        navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "") {
            self.text_view.text = placeHolderText
            self.text_view.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        initialText.hidden = !text_view.text.isEmpty
        if  0 < (141 - text_view.text!.characters.count) {
            tweetButton.enabled = true
            CountsLabel.text = "\(140 - text_view.text!.characters.count)"
        }
        else{
             tweetButton.enabled = false
            CountsLabel.text = "\(140 - text_view.text!.characters.count)"
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
