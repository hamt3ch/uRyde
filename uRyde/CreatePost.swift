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
    
    var createPostDestination:String = String()
    var createPostGasMoney:Bool = false
    var createPostDate:String = String()
    
    @IBOutlet var gas: UILabel!
    @IBOutlet var departTime: UILabel!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var myPicker: UIPickerView!
    @IBOutlet var cityPicker: UIPickerView!
    
    @IBOutlet var GasSwitch: UISwitch!
    let pickerData = ["Akron","Boca Raton","Canton","Cape Coral","Cincinnati","Cleveland","Columbus","Coral Springs","Dayton","Daytona", "Elyria","Fort Lauderdale","Gainesville","Hamilton","Hialeah","Hollywood","Jacksonville","Kettering","Lorain","Miami","Middletown","Miramar","Orlando","St. Petersburg","Parma","Pembroke Pines","Port St. Lucie","Tallahassee","Tampa","Toledo","Youngstown"]
    var selectedCityRow = "Akron"
    
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
        
        //starts in the middle of the picker
        //cityPicker.selectRow(pickerData.count / 2, inComponent: 0, animated: true)

        
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
        selectedCityRow = pickerData[row]
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
            showCreatePostView("Offer") // change subView of CreatePostView
            gas.text = "Need Gas $$$?"
            departTime.text = "Time of Departure:"
            sendButton.setTitle("Make Offer", forState: UIControlState.Normal)
        case 1:
            showCreatePostView("Request")
            gas.text = "Will You Pay?"
            departTime.text = "Desired Departure Date:"
            sendButton.setTitle("Make Request", forState: UIControlState.Normal)
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
        var postType:String = "Offer"  //parsePostIndicator for SaveInBackground
        var postToCreate = PFObject(className: postType) //indicate post type (Offer/Request)
        
        //made by
        postToCreate["madeBy"] = PFUser.currentUser()!.username
        
        //only dateLeaving
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        postToCreate["dateLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
        
        //destination
        postToCreate["destination"] = selectedCityRow
        
        //only timeLeaving
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        postToCreate["timeLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
        
        //in need of gas money (only for offers)
        postToCreate["needGasMoney"] = GasSwitch.on
        
        //willingness to pay gas money (only for requests)
        postToCreate["willIPay"] = GasSwitch.on
        
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
