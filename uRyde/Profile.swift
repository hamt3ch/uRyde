//
//  Profile.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class Profile: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    //profile info
    @IBOutlet var username: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phoneNum: UILabel!
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DON'T put vars before viewDidLoad
        
        //gets current user
        let myself = PFUser.currentUser()
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
    

    
    //logs out user and sends back timeline which will send back to log in page
    @IBAction func logMeOut(sender: UIButton) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            println("logged out successfully")
        }
        
        self.presentLoginViewController()
        
        
    }
    
    //logs out the user
    func presentLoginViewController()
    {
        if (PFUser.currentUser() == nil)
        {
            //calls login view controller
            let login = PFLogInViewController()
            login.fields =
                PFLogInFields.UsernameAndPassword |
                PFLogInFields.LogInButton |
                PFLogInFields.SignUpButton
            
            login.delegate = self
            login.signUpController?.delegate = self
            self.presentViewController(login, animated: true, completion: nil)
            
            

        }
    
    }
    
    
}