
//
//  CreatePost.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/16/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit

class CreatePost: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myPicker: UIPickerView!
    
    let pickerData = ["Request","Offer"]
    
    @IBOutlet var offerView: UIView!      // OfferView Reference and Fields
    
    @IBOutlet var offerDatePicker: UIDatePicker!
    
    
    @IBOutlet var requestView: UIView!  // RequestView Reference and Fields
    
    @IBOutlet var requestDatePicker: UIDatePicker!
    
    
    
    
    
    var postSelection = "Request" // initialize to
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myPicker.delegate = self
        myPicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIPickerDelegates and DataSources
    //MARK: Data Sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //  myLabel.text = pickerData[row]
        postSelection = pickerData[row]     // user chooses between Offer or Request
        showCreatePostView(postSelection) // change subView of CreatePostView
    }
    
    func showCreatePostView(userChoice:String)
    {
        if(userChoice == "Request")
        {
            println("Showing Request View")
            UIView.animateWithDuration(0.2,
            animations: {
                self.offerView.alpha = 0
                self.requestView.alpha = 1
            },
            completion: { (value: Bool) in

            })
        }
        
        else
        {
            println("Showing Offer View")
            UIView.animateWithDuration(0.2,
                animations: {
                    self.offerView.alpha = 1
                    self.requestView.alpha = 0
                },
                completion: { (value: Bool) in
                    
            })
        }
    }
    


}
