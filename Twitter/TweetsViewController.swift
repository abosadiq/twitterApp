//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/12/16.
//  Copyright © 2016 wafi. All rights reserved.
//


import UIKit
import MBProgressHUD
import DOFavoriteButton

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var loadMoreOffset = 20
    @IBOutlet weak var tableView: UITableView!
    var refrechController: UIRefreshControl!
    //let button = DOFavoriteButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "like-action"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networker_Request()
        //self.view.addSubview(button)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
        //self.view.addSubview(button)
        //        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refresher_contorl()
            //tableView.infiniteScrollIndicatorStyle.tintColor = UIColor.grayColor()
            self.tableView.infiniteScrollIndicatorStyle = .Gray
            
            self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
                _ = scrollView as! UITableView
                self.refresher_contorl()
                self.tableView.reloadData()
                self.setupInfiniteScrollView()
            }
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
            self.navigationController!.navigationBar.translucent = false
            //self.navigationController!.navigationBar.tintColor = UIColor.blueColor()
            //self.navigationItem.title = "Twitter"
        }
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController!.navigationBar.tintColor = UIColor.redColor()
        let image_view = UIImageView(frame: CGRect(x: 0, y:0, width:40, height:40))
        image_view.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "tweet")
        image_view.image = image
        self.navigationItem.titleView = image_view
        UIApplication.sharedApplication().statusBarStyle = .Default;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        
        
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
        let label:NSAttributedString = NSAttributedString(string: "Pull me to refresh")
        refrechController.attributedTitle = label
        
        self.refrechController.addTarget(self,action: "refresher:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refrechController)
        refrechController.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        refrechController.tintColor = UIColor(red: 155/255, green: 155/55, blue: 154/25, alpha: 1)
        
        
    }
    func refresher(sender:AnyObject){
        //networker_Request()
        
        self.tableView.reloadData()
        networker_Request()

        self.refrechController.endRefreshing()
         
        
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
        view.endEditing(true)
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
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            
            self.addSubview(activityIndicatorView)
        }
        
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = true
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    
    
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.tweets!.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
            
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
             loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                
                //load more dataz
                loadMoreData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.redColor()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detialSeg") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let DetailsController = segue.destinationViewController as! DetailViewController
               DetailsController.tweet = tweet
            
            
        } else if (segue.identifier) == "ReplySegue" {
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetsTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let user = User.currentUser
            let ReplyController = segue.destinationViewController as! ReplyingViewController
            ReplyController.tweet = tweet
            ReplyController.user = user
        }
        else if (segue.identifier) == "Composed" {
            let user = User.currentUser
            let composedController = segue.destinationViewController as! composedViewController
            composedController.user = user
            
        }
        else if (segue.identifier) == "picSegue"{
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetsTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let UserProfileViewController = segue.destinationViewController as! userViewController
            UserProfileViewController.tweet = tweet
        }
        
        
    }
    
}
