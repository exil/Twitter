//
//  MenuViewController.swift
//  Twitter
//
//  Created by Max Pappas on 2/26/16.
//  Copyright © 2016 Max Pappas. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private var tweetsNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!


    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        
        let mentionsViewController = mentionsNavigationController.childViewControllers[0] as! TweetsViewController
        mentionsViewController.showMentions = true
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        
        let titles = ["Timeline", "Profile", "Mentions"]

        cell.titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
        print("adding view")
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
