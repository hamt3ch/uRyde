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
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
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
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        self.actInd.startAnimating()
        
        PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            self.actInd.stopAnimating() //stop talking to the backend
            if (user != nil) {
                var alert = UIAlertView(title: "Success", message: "You logged in correctly", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                var timelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation.addUniqueObject(PFUser.currentUser()!.username!, forKey: "channels")
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                
                self.presentViewController(timelineVC, animated: true, completion: nil)
            
            } else {
                var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }

}
