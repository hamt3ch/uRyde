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

class Profile: UIViewController, UIImagePickerControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UINavigationControllerDelegate {
    
    //profile info

    @IBOutlet var username: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phoneNum: UILabel!
    @IBOutlet var schoolName: UILabel!
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var picText: UIButton!

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
            let myFirstName: String? = myself!["firstName"] as? String
            let myLastName: String? = myself!["lastName"]  as? String
            name.text = myFirstName! + " " + myLastName!
            
            //email (built-in)
            let myEmail = myself!.objectForKey("email") as! String
            email.text = myEmail
            
            //phone number (custom)
            let myPhoneNumber: String? = myself!["phoneNum"] as? String
            phoneNum.text = myPhoneNumber
            
            if (myself!["picture"] != nil) {
                let myProfPic = myself!["picture"] as! PFFile
                myProfPic.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.profilePic.image = image
                            self.picText.titleLabel?.text = ""
                        }
                    }
                }
            }
            
            let school: String? = myself!["school"] as? String
            schoolName.text = school
            
            profilePic.layer.cornerRadius = 10
            profilePic.clipsToBounds = true
            
        
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //UIParseLoginSegment/////////////////
    
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
        print("Did fail to login", terminator: "")
    }
    
    //logs out user and sends back timeline which will send back to log in page
    @IBAction func logMeOut(sender: UIButton) {
        
        PFUser.logOut()
        if (PFUser.currentUser() == nil)
        {
            //calls login view controller
            
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LogIn
            let navController = UINavigationController(rootViewController: loginVC)
            self.presentViewController(navController, animated: true, completion: nil)
        
        }
    }
    
    //gets pictures from camera's photo library
    //action from add profile pic button

    @IBAction func uploadFromSourceToParse(sender: AnyObject) {
        //uploads from library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadToParse(sender: AnyObject) {
        let imageData = UIImagePNGRepresentation(self.profilePic.image!)
        let imageFile:PFFile = PFFile(data: imageData!)!
        PFUser.currentUser()!["picture"] = imageFile
        PFUser.currentUser()?.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                //save pic
               print("Done", terminator: "")
                
                
            } else {
                print("Something went wrong", terminator: "")
            }
        })
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profilePic.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        

    }

}