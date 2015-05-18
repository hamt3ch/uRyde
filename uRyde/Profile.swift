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
    
    @IBOutlet var userPic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DON'T put vars before viewDidLoad
        
        //gets current user
        let myself = PFUser.currentUser()

        if myself != nil {
            
            //username (built-in)
            let myUserName = myself!.objectForKey("username") as! String
            username.text = myUserName
            
            //name (custom)
            let myFirstName: String? = myself!["FirstName"] as? String
            let myLastName: String? = myself!["LastName"]  as? String
            name.text = myFirstName! + " " + myLastName!
            
            //email (built-in)
            let myEmail = myself!.objectForKey("email") as! String
            email.text = myEmail
            
            //phone number (custom)
            let myPhoneNumber: String? = myself!["phoneNum"] as? String
            phoneNum.text = myPhoneNumber
            
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
        if (PFUser.currentUser() == nil)
        {
            //calls login view controller
            
            var loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LogIn
            var navController = UINavigationController(rootViewController: loginVC)
            self.presentViewController(navController, animated: true, completion: nil)
            /*
            let login = PFLogInViewController()
            login.fields =
            PFLogInFields.UsernameAndPassword |
            PFLogInFields.LogInButton |
            PFLogInFields.SignUpButton
            
            login.delegate = self
            login.signUpController?.delegate = self
            self.presentViewController(login, animated: true, completion: nil)
            */
        
        }
    }
    
}