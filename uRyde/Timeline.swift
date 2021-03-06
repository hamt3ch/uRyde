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

class Timeline: UIViewController, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate, UITabBarControllerDelegate {
    
    var loginViewController = PFLogInViewController()  // instantiate loginView
    var signUpViewController = PFSignUpViewController() // instantiate signupView
  
    @IBOutlet var OfferBackGnd: UIView!
    @IBOutlet var RequestBackGnd: UIView!
    @IBOutlet var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    var myPostArray = NSMutableArray()
    var selectedPostType:String = "Offer"
    
//     let swipeRec = UISwipeGestureRecognizer()
    
    @IBOutlet var swipeView: UIView!

    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register custom cell
        let nibOffer = UINib(nibName: "offerCellView", bundle: nil)
        tableView.registerNib(nibOffer, forCellReuseIdentifier: "offerCell")
        let nibReq = UINib(nibName: "requestCellView", bundle: nil)
        tableView.registerNib(nibReq, forCellReuseIdentifier: "requestCell")
        
        //SwipeToRefresh Initialization
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view, typically from a nib. <-- on point
//        swipeRec.addTarget(self, action: "swipedView")
//        swipeView.addGestureRecognizer(swipeRec)
//        swipeView.userInteractionEnabled = true
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.separatorColor = UIColorFromRGB(0xE62D3B)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //reloads data before even appearing in the view
        retrieveDataFromParse(selectedPostType)
        self.tableView.reloadData()
        
        
       // actIndicator.hidden = true // for now
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.delegate = self       //connect tableview to delegates/DataSource
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = true
        
        tableView.contentSize.width != tableView.bounds.size.width && tableView.contentSize.height != tableView.bounds.size.height;
        
        if(PFUser.currentUser() == nil)
        {
            //customize parse login/signup here
            
            //replaes Parse logo
            let loginLogoTitle = UILabel() //can use UIImage UIButton etc...
            loginLogoTitle.text = "uRyde"
            loginViewController.logInView?.logo = loginLogoTitle
            loginViewController.delegate = self // connect loginView to delegate
            
            //customize SignUpView
            signUpViewController.delegate = self // connect signupView to delegate
            
            // signupBtn >> signupViewController
            loginViewController.signUpController = self.signUpViewController
            
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LogIn
            let navController = UINavigationController(rootViewController: loginVC)
            self.presentViewController(navController, animated: true, completion: nil)
            
        }
        
        /*
        if selectedPostType == "Offer" {
            tableView.separatorColor = UIColor.whiteColor()
        } else {
            tableView.separatorColor = UIColor(red: 17, green: 79, blue: 160, alpha: 1)
        }
        */
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //colors
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.3)
        )
    }
    
    //DataSourceSegment////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //get offer/request
        let tempObject:PFObject = self.myPostArray.objectAtIndex(indexPath.row) as! PFObject
        let postCreator = tempObject["madeBy"] as! String  // get username from post
        let destination = tempObject["destination"] as! String
        let departDate = tempObject["dateLeaving"] as! String
        let userQuery:PFQuery = PFUser.query()! // access user class
        userQuery.whereKey("username", equalTo: postCreator) // find user == postCreator
        
        //for requests
        if (selectedPostType == "Request") {
            let rCell:RequestCell = tableView.dequeueReusableCellWithIdentifier("requestCell") as! RequestCell
            
            let willIPay = tempObject["willIPay"] as? Bool
            //String for request info
            var goingToPay = ""
            if willIPay == false {
                goingToPay = "."
            } else {
                goingToPay = " and is willing to pay for gas."
            }
            rCell.name.text = postCreator
            rCell.destination.text = "Needs a ride to " + "\(destination)" + " on " + "\(departDate)" + "\(goingToPay)"
            
            userQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.", terminator: "")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            let profilePic = object["picture"] as? PFFile
                            
                            profilePic?.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        rCell.rProfPic.image = image
                                        
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)", terminator: "")
                }
            }

            return rCell
            
        //for offers
        } else {
            let oCell:OfferCell = tableView.dequeueReusableCellWithIdentifier("offerCell") as! OfferCell
            oCell.name.text = postCreator
            oCell.destination.text = destination
            let departureDate = departDate
            let departureTime = tempObject["timeLeaving"] as! String
            oCell.date.text = "Leaving on " + "\(departureDate)" + " at " + "\(departureTime)"
            
            userQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.", terminator: "")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            let profilePic = object["picture"] as? PFFile
                            
                            profilePic?.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        oCell.profilePic.image = image
                                        
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)", terminator: "")
                }
            }
            
            let needGasMoney = tempObject["needGasMoney"] as? Bool
            if needGasMoney == false {
                oCell.moneyIcon.hidden = true
            }
            
            return oCell

        }
        
    }
    
    
    //UITableViewSegment////////////////
    //gives user ability to click each cell in table view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        //printmyPostArray.objectAtIndex(row) // getObject in cell
        
        let postCreator = myPostArray.objectAtIndex(row)["madeBy"] as! String
        let postID = myPostArray.objectAtIndex(row)["objectId"]
        print(postCreator, terminator: "")
    
        if(PFUser.currentUser()?.username == postCreator)
        {
            let alert:UIAlertView = UIAlertView()
            alert.title = "You cannot request a ride from yourself."
            //alert.message = "Your workout has been logged into the system"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()
        }

        else
        {
            let offerMessage = "Do you want to request a ride from " + postCreator + "?"
            let requestMessage = "Do you want to give " + postCreator + " a ride to Hugh's kingdom?"
            let refreshAlert = UIAlertController(title: "Confirm", message: selectedPostType == "Offer" ? offerMessage : requestMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            //ok
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                print("Handle Ok logic here", terminator: "")
                let push:PFPush = PFPush() // set channel to postCreator
                push.setChannel(postCreator)
                let notifyOfferMessage = "wants a ride from you!"
                let notifyRequestMessage = "wants to offer you a ride!"
                push.setMessage(postCreator + self.selectedPostType == "Offer" ? notifyOfferMessage : notifyRequestMessage)
       
                //Create Post Object
                let pendingPost = PFObject(className: "Pending")
                pendingPost["sentBy"] = PFUser.currentUser()?.username
                pendingPost["recievedBy"] = postCreator
                pendingPost["accept"] = false
                pendingPost["typeOfPost"] = self.selectedPostType
                pendingPost.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("pendingPost was sent >> Parse", terminator: "")
                        
                        //set APS for data transfer
                        let data = ["alert":(PFUser.currentUser()?.username)! + self.selectedPostType == "Offer" ? notifyOfferMessage : notifyRequestMessage, "badge": "", "content-available":"2", "category":"MY_CATEGORY", "objectId":pendingPost.objectId!]
                        
                        push.setData(data) //attach data to pushNotes
                        push.sendPushInBackground() // send pushNote to otherUser

                    } else {
                        // There was a problem, check error.description
                        print("error sending", terminator: "")
                    }
            }
                

            //disable after confirming later
                
            }))
            
            //cancel
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
                print("Handle Cancel Logic here", terminator: "")
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)     

         }
    
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
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
        print("Failed to login", terminator: "")
    }
    
    //UIParseSignupSegment////////////////////////////////////
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to signup", terminator: "")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("Cancelled signupView", terminator: "")
    }
    
    //Buttons//////////////////
    @IBAction func offerBtnPressed(sender: AnyObject) {
        retrieveDataFromParse("Offer") //populate TableView with Offer Post
        selectedPostType = "Offer"
        OfferBackGnd.alpha = 1 // selected
        RequestBackGnd.alpha = 0.6 // dim
    }
    
    @IBAction func requestBtnPressed(sender: AnyObject) {
        retrieveDataFromParse("Request") //populate Tableview with Request Post
        selectedPostType = "Request"
        OfferBackGnd.alpha = 0.6 // dim
        RequestBackGnd.alpha = 1 // selected
    }
    
    //retrieves data at viewDidLoad the
    func retrieveDataFromParse (selectedPost:String)
    {
        //get query from parse
        let query = PFQuery(className: selectedPost)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            //query parse object and put each object in objects array
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                self.myPostArray.removeAllObjects()
                //populate myPostArray with each parse objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId, terminator: "")
                        self.myPostArray.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing() // indicate new Data is ready
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.", terminator: "")
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)", terminator: "")
            }
        }
        
        
    }
    
    //SwipeToRefresh - Additional Methods
    func refresh(sender:AnyObject)
    {
        retrieveDataFromParse(selectedPostType)
    }
    
    
    //UIGuestures///////////////////////////////
//    func swipedView(){
//        
//        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
//        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
//        self.presentViewController(tapAlert, animated: true, completion: nil)
//    }
    
}
