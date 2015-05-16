//
//  Timeline.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import Parse
import ParseUI
import UIKit

class Timeline: UIViewController, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var myPostArray = NSMutableArray()
    var mySwiftArray: [String] = []
   
  //  var postArrayString:Array = [""]
  //  var postArray:NSMutableArray = []
    
    let swiftBlogs = ["Progress", "Strength Exercises", "Activites", "Achieved Goal Congratulations", "Next Message", "Then the Message After That", "And So on..."]
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         // intialize data
        tableView.delegate = self       //connect tableview to delegates/DataSource
        tableView.dataSource = self
        retrieveDataFromParse()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(PFUser.currentUser() == nil)
        {
            //customize parse login here
            
            var loginViewController = PFLogInViewController()  // instantiate loginView
            
            loginViewController.delegate = self // connect loginView to delegate
            
            var signUpViewController = PFSignUpViewController() // instantiate signupView
            
            signUpViewController.delegate = self // connect signupView to delegate
            
            loginViewController.signUpController = signUpViewController // signupBtn >> signupViewController
            
            self.presentViewController(loginViewController, animated: true, completion: nil) // push to screen
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DataSourceSegement////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySwiftArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = mySwiftArray[row]
        return cell
    }
    
    
    //UITableViewSegement////////////////
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(swiftBlogs[row]) // NS Log(cell.text)
    }
    
    

    //UIParseLoginSegement/////////////////
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty)
        {
            return true
        }
        
        else
        {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        //User for logged in
         self.dismissViewControllerAnimated(true, completion: nil) // dismiss loginView
    
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        //User failed to login
        println("Did fail to login")
    }
    
    //UIParseSignupSegement////////////////////////////////////
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("Cancelled signupView")
    }
    
    //Buttons//////////////////
    @IBAction func offerBtnPressed(sender: AnyObject) {
        
        var query = PFQuery(className:"Request")
        
        //query.whereKey("playerName", equalTo:"Sean Plott")
        //query.whereKey("madeBy", containedIn: "Request")
        
        var postArray = NSMutableArray()
       
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
    
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                       // println(object.objectForKey("madeBy"))
                        postArray.addObject(object["madeBy"] as! String)
                    }
                    
                    self.myPostArray = postArray
                    println(self.myPostArray)
                }
            }
             
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }

        
    }
    
    @IBAction func requestBtnPressed(sender: AnyObject) {
        
//        var user = PFUser.currentUser()
//        println(user!.objectForKey("email") as! String)
//        let email = user!.objectForKey("email") as! String
        println(self.myPostArray)
        
    }
    
    func retrieveDataFromParse ()
    {
        var query = PFQuery(className:"Request")
        
        //query.whereKey("playerName", equalTo:"Sean Plott")
        //query.whereKey("madeBy", containedIn: "Request")
        
        var postArray = NSMutableArray() // create mutable array
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        // println(object.objectForKey("madeBy"))
                        postArray.addObject(object["madeBy"] as! String)
                    }
                
                    self.myPostArray = postArray
                    self.mySwiftArray = postArray as AnyObject as! [String]
                    self.tableView.reloadData() // reload data from Parse into tableView

                    
                }
            }
                
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }

        
    }
    
}