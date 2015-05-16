//
//  Profile.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse

class Profile: UIViewController {
    
    //profile info
    @IBOutlet var username: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phoneNum: UILabel!
    
    //get current user
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DON'T put vars before viewDidLoad
        //
        var myself = PFUser.currentUser()
        var query = PFQuery(className:"_User")
        if myself != nil {
            
            //username
            let myUserName = myself!.objectForKey("username") as! String
            username.text = myUserName
            /*
            //name
            let myFirstName = myself!.objectForKey("FirstName")  as! String
            let myLastName = myself!.objectForKey("LastName")  as! String
            name.text = "\(myFirstName)" + " " + "\(myLastName)"
            */
            //email
            let myEmail = myself!.objectForKey("email") as! String
            email.text = myEmail
            /*
            //phone number
            let myPhoneNumber = myself!.objectForKey("phone") as! String
            phoneNum.text = myPhoneNumber
            */
            
            
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}