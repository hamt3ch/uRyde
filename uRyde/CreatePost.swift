//
//  CreatePost.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/16/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse
/*
public enum Post: String {
    case Offer = "Offer"
    case Request = "Request"
}
*/
class CreatePost: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var postSelection:String = "Offer"
    var createPostDestination:String = String()
    var createPostGasMoney:Bool = false
    var createPostDate:String = String()
    
    @IBOutlet var gas: UILabel!
    @IBOutlet var departTime: UILabel!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var myPicker: UIPickerView!
    @IBOutlet var cityPicker: UIPickerView!
    
    @IBOutlet var GasSwitch: UISwitch!
    let pickerData = ["Alafaya", "Altamonte Springs", "Apopka", "Aventura", "Bayonet Point",
    "Bellview", "Bloomingdale", "Boca Raton", "Bonita Springs", "Boynton Beach",
    "Bradenton", "Brent", "Buenaventura Lakes", "Cape Coral", "Carrollwood",
    "Casselberry", "Citrus Park", "Clearwater", "Clermont", "Coconut Creek",
    "Cooper City", "Coral Gables", "Coral Springs", "Coral Terrace", "Country Club",
    "Crestview", "Cutler Bay", "Dania Beach", "Davie", "Daytona Beach", "Deerfield Beach",
    "Deland", "Delray Beach", "Deltona", "Doral", "Dunedin", "East Lake",
    "East Lake-Orient Park", "Edgewater", "Egypt Lake-Leto", "Ensley", "Estero",
    "Ferry Pass", "Fleming Island", "Fort Lauderdale", "Fort Myers", "Fort Pierce",
    "Fort Walton Beach", "Fountainebleau", "Four Corners", "Fruit Cove", "Gainesville",
    "Golden Gate", "Golden Glades", "Greenacres", "Haines City", "Hallandale Beach",
    "Hialeah", "Hialeah Gardens", "Holiday", "Hollywood", "Homestead", "Immokalee",
    "Jacksonville", "Jacksonville Beach", "Jupiter", "Kendale Lakes", "Kendall",
    "Kendall West", "Keystone", "Key West", "Kissimmee", "Lakeland", "Lake Worth",
    "Land O' Lakes", "Largo", "Lauderdale Lakes", "Lauderhill", "Leesburg",
    "Lehigh Acres", "Leisure City", "Margate", "Meadow Woods", "Melbourne",
    "Merritt Island", "Miami", "Miami Beach", "Miami Gardens", "Miami Lakes",
    "Miramar", "Naples", "Navarre", "New Smyrna Beach", "Northdale",
    "North Fort Myers", "North Lauderdale", "North Miami", "North MIami Beach",
    "North Port", "Oakland Park", "Oakleaf Plantation", "Oak Ridge", "Ocala",
    "Ocoee", "Orlando", "Ormond Beach", "Oviedo", "Pace", "Palm Bay",
    "Palm Beach Gardens", "Palm City", "Palm Coast", "Palmetto Bay", "Palm Harbor",
    "Palm River-Clair Mel", "Palm Springs", "Palm Valley", "Panama City", "Parkland",
    "Parkland", "Pembroke Pines", "Pensacola", "Pine Hills", "Pinellas Park", "Plantation",
    "Plant City", "Poinciana", "Pompano Beach", "Port Charlotte", "Port Orange",
    "Port St. Lucie", "Princeton", "Richmond West", "Riverview", "Riviera Beach",
    "Rockledge", "Royal Palm Beach", "Sanford", "Sarasota", "Sebastian", "South Bradenton",
    "South Miami Heights", "Spring Hill", "St. Cloud", "St. Petersburg", "Sunny Isles Beach",
    "Sunrise", "Sweetwater", "Tallahassee", "Tamarac", "Tamiami", "Tampa", "Tarpon Springs",
    "Temple Terrace", "The Acreage", "The Crossings", "The Hammocks", "The Villages",
    "Titusville", "Town 'n' Country", "Unversity", "University Park", "Valrico", "Venice",
    "Vero Beach South", "Wekiva Springs", "Wellington", "Wesley Chapel", "Westchase",
    "Westchester", "West Little River", "Weston", "West Palm Beach", "West Pensacola",
    "Winter Garden", "Winter Haven", "Winter Park", "Winter Springs", "Wright"]
    var selectedCityRow = "Alafaya" //first one for now
    
    @IBOutlet var offerView: UIView!      // OfferView Reference and Fields
    @IBOutlet var offerDatePicker: UIDatePicker!
    
    @IBOutlet var requestView: UIView!  // RequestView Reference and Fields
    @IBOutlet var requestDatePicker: UIDatePicker!

    @IBOutlet var SegmentCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //offerDatePicker.datePickerMode = UIDatePickerMode.DateAndTime  // Set UIDatePickers for Date and Time Mode
        //requestDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        let currentDate = NSDate()  // setTempVariable to CurrentDate
        
        offerDatePicker.minimumDate = currentDate // intialize OfferDatePicker Values
        let gregorian:NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        offerDatePicker.date = currentDate
        let dateComponents = NSDateComponents()
        dateComponents.month = 3
        let endingDate:NSDate = gregorian.dateByAddingComponents(dateComponents, toDate: currentDate, options: .MatchStrictly) as NSDate!
        //max date will only be three months from now
        offerDatePicker.maximumDate = endingDate
        print(endingDate, terminator: "")
        requestDatePicker.minimumDate = currentDate // intialize RequestDatePicker Values
        requestDatePicker.date = currentDate
        requestDatePicker.maximumDate = endingDate
        
        SegmentCtrl.setTitle("Offer", forSegmentAtIndex: 0) // initialize segCtrl text
        SegmentCtrl.setTitle("Request", forSegmentAtIndex: 1)
        
        myPicker.delegate = self     // connect delegates
        myPicker.dataSource = self
        cityPicker.delegate = myPicker.delegate
        cityPicker.dataSource = myPicker.dataSource
        
        
        //starts in the middle of the picker
        //cityPicker.selectRow(pickerData.count / 2, inComponent: 0, animated: true)

        showCreatePostView(postSelection)
        sendButton.setTitle("+Post", forState: UIControlState.Normal)
        
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
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
            print("Showing Request View", terminator: "")
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
            print("Showing Offer View", terminator: "")
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
            //sendButton.setTitle("+Offer", forState: UIControlState.Normal)
            postSelection = "Offer"
            
        case 1:
            showCreatePostView("Request")
            gas.text = "Will You Pay?"
            departTime.text = "Desired Departure Date:"
            //sendButton.setTitle("+Request", forState: UIControlState.Normal)
            postSelection = "Request"
        default:
            break         }
    }
    
    @IBAction func switchTgl(sender: UISwitch) {
        if(GasSwitch.on)
        {
            print("Switch on", terminator: "")
        }
            
        else
        {
            print("Switch off", terminator: "")
        }
    }
    
    @IBAction func sendToParse(sender: AnyObject) {
        let postType:String = postSelection  //parsePostIndicator for SaveInBackground
        let postToCreate = PFObject(className: postType) //indicate post type (Offer/Request)

        //made by
        postToCreate["madeBy"] = PFUser.currentUser()!.username
        
        //only dateLeaving
        let dateFormatter = NSDateFormatter()
        
        //destination
        postToCreate["destination"] = selectedCityRow
        
        //only timeLeaving
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        postToCreate["timeLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
        
        print(postType, terminator: "")
        //$$$
        if (postType == "Offer") {
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .NoStyle
            postToCreate["dateLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
            postToCreate["needGasMoney"] = GasSwitch.on
        }
        if (postType == "Request") {
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .NoStyle
            postToCreate["dateLeaving"] = dateFormatter.stringFromDate(requestDatePicker.date)
            postToCreate["willIPay"] = GasSwitch.on
        }
        
        postToCreate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved. Now return to timeline
                let timelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                self.presentViewController(timelineVC, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    

    

}
