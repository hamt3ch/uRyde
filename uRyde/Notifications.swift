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
    
    var userListPost:NSMutableArray = NSMutableArray()
    
    var currentUserStr = String()
    
    let textCellIdentifier = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myself = PFUser.currentUser()
        self.currentUserStr = (myself!["username"] as? String)!
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!

        
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
    
    
    //UITableViewSegment////////////////
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        launchMessageComposeViewController()
        
        
    }
    
    func retrieveUserListFromParse(){
        self.userListPost.removeAllObjects() //clear userList
        
        //var userQuery:PFQuery = PFUser.query()!
        var userQuery:PFQuery = PFQuery(className: "Pending")
        userQuery.orderByAscending("username")
        userQuery.whereKey("username", notEqualTo: currentUserStr)
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
    func launchMessageComposeViewController() {
        
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = ["9417378620"]
            messageVC.body = "This is Hugh Miles (hmiles23) do you still need a ride"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        
        else {
            println("User hasn't setup Messages.app")
        }
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(textMessageRecipients:[String] ,textBody body:String) -> MFMessageComposeViewController {
        
        let messageComposeVC = MFMessageComposeViewController()
        
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        
        messageComposeVC.recipients = textMessageRecipients
        
        messageComposeVC.body = body
        
        return messageComposeVC
        
    }

    
    
    }

    
    


