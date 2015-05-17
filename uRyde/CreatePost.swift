
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
    @IBOutlet var cityPicker: UIPickerView!
    
    @IBOutlet var GasSwitch: UISwitch!
    let pickerData = ["Cincinnati","Gainesville","Miami","Cleveland"]
    
    @IBOutlet var offerView: UIView!      // OfferView Reference and Fields
        @IBOutlet var offerDatePicker: UIDatePicker!
    
    
    @IBOutlet var requestView: UIView!  // RequestView Reference and Fields
        @IBOutlet var requestDatePicker: UIDatePicker!
    
    
    @IBOutlet var SegementCtrl: UISegmentedControl!

    var postSelection = "Request" // initialize to
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        offerDatePicker.datePickerMode = UIDatePickerMode.DateAndTime  // Set UIDatePickers for Date and Time Mode
        requestDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        let currentDate = NSDate()  // setTempVariable to CurrentDate
        
        offerDatePicker.minimumDate = currentDate // intialize OfferDatePicker Values
        offerDatePicker.date = currentDate
        
        requestDatePicker.minimumDate = currentDate // intialize OfferDatePicker Values
        requestDatePicker.date = currentDate
        
        SegementCtrl.setTitle("Offer", forSegmentAtIndex: 0) // initialize segCtrl text
        SegementCtrl.setTitle("Request", forSegmentAtIndex: 1)
        
        myPicker.delegate = self     // connect delegates
        myPicker.dataSource = self
        cityPicker.delegate = myPicker.delegate
        cityPicker.dataSource = myPicker.dataSource
        
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
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch SegementCtrl.selectedSegmentIndex
        {
        case 0:
            showCreatePostView("Offer") // change subView of CreatePostView
        case 1:
            showCreatePostView("Request")
        default:
            break         }
    }

    @IBAction func switchTgl(sender: UISwitch) {
        if(GasSwitch.on)
        {
            println("Switch on")
        }
        
        else
        {
            println("Switch off")
        }
    }

}
