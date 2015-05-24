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

class SignUp: UIViewController, UITextFieldDelegate {
    
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
        email.delegate = self
        schoolName.delegate = self
        phoneNum.delegate = self
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
        
        //QA
        //---------------------------------------------------------------------------------------------
        //checks that name ONLY contains letters
        //if (self.firstName
        //checks username length
        if count(self.username.text) <= 6 || count(self.username.text) >= 20  {
            var alert = UIAlertView(title: "Error", message: "Username must be between 6 and 20 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        //checks password length
        if count(self.password.text) <= 6 || count(self.password.text) >= 20 {
            var alert = UIAlertView(title: "Error", message: "Password must be between 6 and 20 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        //checks email validity
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.edu"
        let range = self.email.text.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        if range == nil {
            var alert = UIAlertView(title: "Error", message: "This app is for students. Please use a valid .edu account.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        //checks school validity
            //make autocompletion
            
        //checks number validity
        if count(self.phoneNum.text) != 10 || count(self.phoneNum.text) != 11 {
            var alert = UIAlertView(title: "Error", message: "Not a valid phone number.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        //---------------------------------------------------------------------------------------------
        else {
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
                        
                    }
                        
                    else {
                        
                        var alert = UIAlertView(title: "Success", message: "Welcome to uRyde, " + self.firstName.text + "!", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        var timelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                        self.presentViewController(timelineVC, animated: true, completion: nil)
                    }
                    
                })
            }
                
            else {
                var alert = UIAlertView(title: "Error", message: "Passwords don't match.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }

        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        email.resignFirstResponder()
        schoolName.resignFirstResponder()
        phoneNum.resignFirstResponder()
        self.view.endEditing(true)
    }
    
}

