//
//  FirstViewController.swift
//  ThisRightHere
//
//  Created by Peyt Spencer Dewar on 5/24/15.
//  Copyright (c) 2015 PSD. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        name.becomeFirstResponder()
    }

    @IBAction func loginButton(sender: AnyObject) {
        if name.text.isEmpty {
            return
        } else {
            let appD = UIApplication.sharedApplication().delegate as! AppDelegate
            appD.createSinchClient(name.text)
            super.performSegueWithIdentifier("hiSecond", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

