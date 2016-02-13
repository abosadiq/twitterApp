//
//  TwitterClient.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/11/16.
//  Copyright © 2016 wafi. All rights reserved.
//

import UIKit


let twitterConsumerKey = "5qtq9cPEQro5QgrLEcy4qsfX8"
let twitterConsumerSecret = "YvpQSp8gMn1QQpWhsfaoPd9xbqwudQP5KMBOxDgrTVBvuXoqWI"
let TwitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginWithCompletion:((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: TwitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                // print("home Timeline: \(response!)")
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home Timeline")
                completion(tweets: nil, error: error)
        })

        }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginWithCompletion = completion
        
        // Fetch Request Token & redirect authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) {(error: NSError!) -> Void in
                print("Failed to get request token: \(error)")
                self.loginWithCompletion!(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL){
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("The access has been taken")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET(
                "1.1/account/verify_credentials.json",
                parameters: nil,
                success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                    // print("user: \(response!)")
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    print("user: \(user.name)")
                    self.loginWithCompletion?(user: user, error: nil)
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginWithCompletion?(user: nil, error: error)
            })
            
            
            
            
            
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to recieve access token")
                self.loginWithCompletion!(user: nil, error: error)
        }
    }
    

}
