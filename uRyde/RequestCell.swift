//
//  requestCellView.swift
//  uRyde
//
//  Created by Peyt Spencer Dewar on 5/25/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet var rProfPic: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var destination: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rProfPic.layer.cornerRadius = rProfPic.frame.height / 2;
        rProfPic.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
