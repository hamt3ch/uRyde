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
    @IBOutlet var phoneNum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

