//
//  ViewController.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUp: UIViewController {
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPass: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var schoolName: UITextField!
    @IBOutlet var phoneNum: UITextField!
    
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

    @IBAction func signupAction(sender: AnyObject) {
        self.actInd.startAnimating()
        
        if (self.password.text == self.confirmPass.text) {
            var newUser = PFUser()
            println(self.firstName.text)
            newUser["firstName"] = self.firstName.text
            newUser["lastName"] = self.lastName.text
            newUser.username = self.username.text
            newUser.password = self.confirmPass.text
            newUser.email = self.email.text
            newUser["school"] = self.schoolName.text
            newUser["phoneNum"] = self.phoneNum.text
            
            
            newUser.signUpInBackgroundWithBlock ({ (succeed, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((error) != nil) {
                    
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                    
                }else {
                    
                    var alert = UIAlertView(title: "Success", message: "Welcome!", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    var timelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                    self.presentViewController(timelineVC, animated: true, completion: nil)
                }
                
            })
        } else {
            var alert = UIAlertView(title: "Error", message: "Passwords don't match.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
}

