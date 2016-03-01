//
//  notifigationViewController.swift
//  Twitter
//
//  Created by Wafi MoHamed on 2/29/16.
//  Copyright © 2016 Tejen. All rights reserved.
//

import UIKit

class notifigationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.navigationController!.navigationBar.translucent = false
        //self.navigationController!.navigationBar.tintColor = UIColor.blueColor()
        //self.navigationItem.title = "Twitter"
    
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    self.navigationController!.navigationBar.tintColor = UIColor.redColor()


        // Do any additional setup after loading the view.
    }

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
