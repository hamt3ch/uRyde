//
//  Notifications.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse

class Notifications: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var directMessageTblView: UITableView!
    
    var userListPost:NSMutableArray = NSMutableArray()
    
    var currentUserStr = String()
    
    let textIdentifier = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        directMessageTblView.delegate = self
        directMessageTblView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        let myself = PFUser.currentUser()
        self.currentUserStr = (myself!["username"] as? String)!
        retrieveUserListFromParse()
    }
    
    //DataSourceSegment////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = directMessageTblView.dequeueReusableCellWithIdentifier(textIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row

        return cell
    }
    
    
    //UITableViewSegment////////////////
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func retrieveUserListFromParse(){
        self.userListPost.removeAllObjects() //clear userList
        
        var userQuery:PFQuery = PFQuery()
        userQuery.orderByAscending("username")
        userQuery.whereKey("username", notEqualTo: currentUserStr)
        userQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println(object.objectId)
                        }
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
        
    
    }

    
    
}

