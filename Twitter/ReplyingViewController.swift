//
//  ReplyingViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/28/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class ReplyingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var Text_view: UITextView!
    @IBOutlet weak var text_field: UITextField!
    //@IBOutlet weak var text_View: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var ReplyLetterCounts: UILabel!
    @IBOutlet weak var userhadel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!
    //   var handleLabelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        1
        // Do any additional setup after loading the view.
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
            profileImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("nothing Showed")
        }
       username.text = "\((user?.name)!)"
        userhadel.text = "@\(user!.screenname!)"
      Text_view.delegate = self
       ReplyLetterCounts.text = "140"
       Text_view.text = "@\(tweet!.user!.screenname!)\n"
        Text_view.becomeFirstResponder()
       replyButton.enabled = false
        username.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        if  0 < (141 - Text_view.text!.characters.count) {
          replyButton.enabled = true
            ReplyLetterCounts.text = "\(140 - Text_view.text!.characters.count)"
        }
        else{
          replyButton.enabled = false
            ReplyLetterCounts.text = "\(140 - Text_view.text!.characters.count)"
        }
}
    
    @IBAction func onReply(sender: AnyObject) {
        tweetMessage = Text_view.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        TwitterClient.sharedInstance.ReplyToTweet(TweetMessage!, statusID: Int(tweet!.id)!, params: nil, completion: { (error) -> () in
        })
        navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    


    }
