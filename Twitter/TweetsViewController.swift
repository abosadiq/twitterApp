//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/12/16.
//  Copyright © 2016 wafi. All rights reserved.
//


import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    var refrechController: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        networker_Request()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
        
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
             self.refresher_contorl()
            
             }
    }    
    func networker_Request(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in

                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tweets = tweets
                self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    func  refresher_contorl(){
        self.refrechController = UIRefreshControl()
        self.refrechController.attributedTitle = NSAttributedString(string: "Pull me to refresh")
        
        self.refrechController.addTarget(self,action: "refresher:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refrechController)
      refrechController.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    refrechController.tintColor = UIColor(red: 155/255, green: 155/255, blue: 154/255, alpha: 1)
        
    }
    func refresher(sender:AnyObject){
        self.tableView.reloadData()
            networker_Request()
        self.refrechController.endRefreshing()
    }

    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser!.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            
            return tweets.count
            
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.TimesCreater.text = tweets![indexPath.row].Time!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    
    

}
