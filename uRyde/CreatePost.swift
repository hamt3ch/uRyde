//
//  CreatePost.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/16/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse

class CreatePost: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var postType:String = "Offer"  //parsePostIndicator for SaveInBackground
    var createPostDestination:String = String()
    var createPostGasMoney:Bool = false
    var createPostDate:String = String()
    
    @IBOutlet var myPicker: UIPickerView!
    @IBOutlet var cityPicker: UIPickerView!
    
    @IBOutlet var GasSwitch: UISwitch!
    let pickerData = ["Cincinnati","Gainesville", "Miami sucks", "Orlando", "Tampa", "Dayton", "Cleveland", "Boca Raton"]
    
    @IBOutlet var offerView: UIView!      // OfferView Reference and Fields
    @IBOutlet var offerDatePicker: UIDatePicker!
    
    @IBOutlet var requestView: UIView!  // RequestView Reference and Fields
    @IBOutlet var requestDatePicker: UIDatePicker!

    @IBOutlet var SegmentCtrl: UISegmentedControl!
    
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
        
        SegmentCtrl.setTitle("Offer", forSegmentAtIndex: 0) // initialize segCtrl text
        SegmentCtrl.setTitle("Request", forSegmentAtIndex: 1)
        
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = UILabel()
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(pickerData.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 0.5)
            pickerLabel.textAlignment = .Center
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Bold", size: 18.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.attributedText = myTitle
        
        return pickerLabel
        
    }
    
    //size the components of the UIPickerView
    //row height
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    /*
    //row width
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    */
    
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
        
        switch SegmentCtrl.selectedSegmentIndex
        {
        case 0:
            self.postType = "Offer"
            showCreatePostView("Offer") // change subView of CreatePostView
        case 1:
            self.postType = "Request"
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
    
    @IBAction func sendToParse(sender: AnyObject) {
        var postToCreate = PFObject(className: postType) //indicate post type (Offer/Request)
        postToCreate["madeBy"] = PFUser.currentUser()!.username
        let dateFormatter = NSDateFormatter()
        
        if (self.postType == "Offer") {
            
            //only timeLeaving
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            postToCreate["timeLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
        }
        
        if (self.postType == "Request") {
            
        }
        
        //only dateLeaving
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        postToCreate["dateLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
        
        
        postToCreate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    

    

}
