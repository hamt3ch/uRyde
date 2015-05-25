//
//  TableCell.swift
//  uRyde
//
//  Created by Peyt Spencer Dewar on 5/17/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class OfferCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var destination: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var moneyIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.layer.cornerRadius = 10;
        profilePic.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
