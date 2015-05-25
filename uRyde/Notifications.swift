//
//  Notifications.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class Notifications: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var directMessageTblView: UITableView!
    var tableView: UITableView!
    
    var userListPost:NSMutableArray = NSMutableArray()
    
    var currentUserStr = String()
    
    let textCellIdentifier = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myself = PFUser.currentUser()
        self.currentUserStr = (myself!["username"] as? String)!
        directMessageTblView.delegate = self
        directMessageTblView.dataSource = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        retrieveUserListFromParse()
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
        return userListPost.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = directMessageTblView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        var tempObject:PFObject = self.userListPost.objectAtIndex(indexPath.row) as! PFObject
        
        cell.textLabel?.text = tempObject["sentBy"] as! String
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    
    //UITableViewSegment////////////////
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var tempObject:PFObject = self.userListPost.objectAtIndex(indexPath.row) as! PFObject
        let userTryingContact = tempObject["sentBy"] as! String
        
        var userQuery:PFQuery = PFUser.query()!
         userQuery.whereKey("username", equalTo: userTryingContact)
         userQuery.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            // The find succeeded.
            if error == nil
            {  // Do something with the found objects
                if let objects = objects as? [PFObject]
                {
                    for object in objects
                    {
                        let phoneNumber = object["phone"] as! String
                        let myself = PFUser.currentUser()?.username
                        self.launchMessageComposeViewController(phoneNumber, currentUser: myself)
                    }
                }
            }
        }
    }
    
    func retrieveUserListFromParse(){
        self.userListPost.removeAllObjects() //clear userList
        
        //var userQuery:PFQuery = PFUser.query()!
        var userQuery:PFQuery = PFQuery(className: "Pending")
        userQuery.orderByAscending("username")
        userQuery.whereKey("sentBy", notEqualTo: self.currentUserStr)
        userQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            // The find succeeded.
            println("Successfully retrieved \(objects!.count) scores.")
            
                if error == nil
                {
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        
                        for object in objects {
                            self.userListPost.addObject(object)
                            print(self.userListPost)
                            
                        }
                    }
                    
                      self.directMessageTblView.reloadData()
                        
                        
                }
            
                else
                {
                    println("Error from notificationsQuery")
                
                }
                    
            }
        
        
        
        }
        
//        [self.chatMatesArray removeAllObjects];
//        
//        PFQuery *query = [PFUser query];
//        [query orderByAscending:@"username"];
//        [query whereKey:@"username" notEqualTo:self.myUserId];
//        
//        __weak typeof(self) weakSelf = self;
//        [query findObjectsInBackgroundWithBlock:^(NSArray *chatMateArray, NSError *error) {
//        if (!error) {
//        for (int i = 0; i < [chatMateArray count]; i++) {
//        [weakSelf.chatMatesArray addObject:chatMateArray[i][@"username"]];
//        }
//        [weakSelf.tableView reloadData];
//        } else {
//        NSLog(@"Error: %@", error.description);
//        }
//        }];
//    
    
    //MessageUI - Delegate
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MessageUI - AdditionalMethods
    
    // prepend this function with @IBAction if you want to call it from a Storyboard.
    func launchMessageComposeViewController(recipient:String!, currentUser:String!) {
        
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = [recipient]
            messageVC.body = "This is " + currentUser + " do you still need a ride?"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        
        else {
            println("User hasn't setup Messages.app")
        }
    }
}

    
    


