//
//  ViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/12/16.
//  Copyright © 2016 wafi. All rights reserved.
//


import UIKit
import AFNetworking
import BDBOAuth1Manager



class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.view.backgroundColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */

        //loginButton.tintColor = UIColor.redColor()

        if User.currentUser != nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {

        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //self.performSegueWithIdentifier("loginSegue", sender: self)

            }
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        
        if User.currentUser != nil{
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
        
    }
    

}

