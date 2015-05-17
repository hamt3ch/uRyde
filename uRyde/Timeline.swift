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

class Timeline: UIViewController, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate {
    
    var loginViewController = PFLogInViewController()  // instantiate loginView
    var signUpViewController = PFSignUpViewController() // instantiate signupView
    
    @IBOutlet var tableView: UITableView!
    
    var myPostArray = NSMutableArray()
    
    //use this array to populate the cell
    //var mySwiftArray: [String] = []
    
    /*
    var postArrayString:Array = [""]
    var postArray:NSMutableArray = []
    
    let swiftBlogs = ["I", "am", "cooler", "than", "Hugh", "Anthony", "Miles"]
    
    let textCellIdentifier = "TextCell"
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register custom cell
        var nib = UINib(nibName: "tableCellView", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "offerCell")
        
        retrieveDataFromParse("Offer")

        
        // Do any additional setup after loading the view, typically from a nib. <-- on point
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.delegate = self       //connect tableview to delegates/DataSource
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = true
        
        tableView.contentSize.width != tableView.bounds.size.width && tableView.contentSize.height != tableView.bounds.size.height;
        
         // intialize post
        
        if(PFUser.currentUser() == nil)
        {
            //customize parse login/signup here
            
            //replaes Parse logo
            var loginLogoTitle = UILabel() //can use UIImage UIButton etc...
            loginLogoTitle.text = "uRyde"
            loginViewController.logInView?.logo = loginLogoTitle
            loginViewController.delegate = self // connect loginView to delegate
            
            //customize SignUpView
            signUpViewController.delegate = self // connect signupView to delegate
            
            // signupBtn >> signupViewController
            loginViewController.signUpController = self.signUpViewController
            
            var loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LogIn
            var navController = UINavigationController(rootViewController: loginVC)
            self.presentViewController(navController, animated: true, completion: nil)
        
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DataSourceSegment////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TableCell = tableView.dequeueReusableCellWithIdentifier("offerCell") as! TableCell
        
        //get offer/request
        var tempObject:PFObject = self.myPostArray.objectAtIndex(indexPath.row) as! PFObject
        cell.name.text = tempObject["madeBy"] as? String
        cell.destination.text = tempObject["destination"] as? String
        let departureDate = tempObject["dateLeaving"] as! String
        let departureTime = tempObject["timeLeaving"] as! String
        cell.date.text = "Leaving on " + "\(departureDate)" + " at " + "\(departureTime)"

        //FOR LATE USE
        //for images: cell.userImage = UIImage(named: "u_turn_symbol")
        
        return cell
    }
    
    
    //UITableViewSegment////////////////
    //gives user ability to click each cell in table view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(myPostArray.objectAtIndex(row)) // getObject in cell
        
        let postCreator = myPostArray.objectAtIndex(row)
        /*
        if(PFUser.currentUser()?.username == postCreator as! String)
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "You cannot request a ride from yourself"
            //alert.message = "Your workout has been logged into the system"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()
        }

        else
        {
            var push:PFPush = PFPush() // set channel to postCreator
            push.setChannel(postCreator as! String)
            push.setMessage((postCreator as! String) + "Wants a Ride")
            var data:NSDictionary = ["alert":(PFUser.currentUser()?.username)! + " wants a Ride", "badge":"", "content-available":"2","sound":"" , "phone": "usersphonenumber" ]
            
            push.setData(data as [NSObject : AnyObject]) //attach data to pushNotes
            push.sendPushInBackground()
           
        }
        */
    }

    //UIParseLoginSegment/////////////////
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
        println("Failed to login")
    }
    
    //UIParseSignupSegment////////////////////////////////////
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("Cancelled signupView")
    }
    
    //Buttons//////////////////
    @IBAction func offerBtnPressed(sender: AnyObject) {
        retrieveDataFromParse("Offer") //populate TableView with Offer Post
    }
    
    @IBAction func requestBtnPressed(sender: AnyObject) {
        retrieveDataFromParse("Request") //populate Tableview with Request Post
    }
    
    //retrieves data at viewDidLoad the
    func retrieveDataFromParse (selectedPost:String)
    {
        //get query from parse
        var query = PFQuery(className: selectedPost)
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            //query parse object and put each object in objects array
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil
            {
                self.myPostArray.removeAllObjects()
                //populate myPostArray with each parse objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        self.myPostArray.addObject(object)
                    }
                }
                self.tableView.reloadData()
                
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) posts.")
            }
            else
            {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    /*
        var query = PFQuery(className: selectedPost)
        
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
    */
}