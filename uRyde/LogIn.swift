//
//  ViewController.swift
//  uRyde
//
//  Created by Peyt Spencer Dewar on 5/16/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse

class LogIn: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var usernameTap: UIView!
    @IBOutlet var passwordTap: UIView!
    @IBOutlet var userExt: UIView!
    @IBOutlet var passExt: UIView!
    

    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        //override for Tap take off once tap guesture works for input fields
        userExt.alpha = 0.8
        passExt.alpha = 0.8
        usernameTap.alpha = 0
        passwordTap.alpha = 0;
        
        //initializeTap
//        var inputs = [passwordTap,usernameTap]
//        for i in inputs{
//            i.userInteractionEnabled = true
//            let tapGuesture = UITapGestureRecognizer()
//            tapGuesture.addTarget(self, action: "tappedView:")
//            i.addGestureRecognizer(tapGuesture)
//        }

        
        
        //view.addSubview(self.actInd)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginAction(sender: AnyObject) {
        //checks correct login info
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        self.actInd.startAnimating()
        
        PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
            self.actInd.stopAnimating() //stop talking to the backend
            if (user != nil) {
                var verified = PFUser.currentUser()?.objectForKey("emailVerified") as! Bool
//                if (verified) {
                    let alert = UIAlertView(title: "Success", message: "You logged in correctly!", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    let timelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                    
                    let installation:PFInstallation = PFInstallation.currentInstallation()
                    installation.addUniqueObject(PFUser.currentUser()!.username!, forKey: "channels")
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackground()
                    
                    self.presentViewController(timelineVC, animated: true, completion: nil)
//                } else {
//                    var alert = UIAlertView(title: "Confirm Email", message: "Please check your email to verify your account.", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()

                
            
            } else {
                let alert = UIAlertView(title: "Error", message: "Username/password combination does not exist.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //tappedInput - When user touches textbox
    func tappedView(sender:UITapGestureRecognizer) {
        
//        if(sender.view!.tag == 0){//username
//            usernameTap.alpha = 0 // turn off TapGuestView
//            usernameField.alpha = 1 // showtextField
//            userExt.alpha = 1
//        }
//        
//        else if(sender.view!.tag == 1) {//password
//            passwordTap.alpha = 0 // turn on TapGuestView
//            passwordField.alpha = 1 // set password back to normal
//            passExt.alpha = 1
//        }
        
    }
}
