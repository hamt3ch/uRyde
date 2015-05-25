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
    @IBOutlet var rInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rProfPic.layer.cornerRadius = 10;
        rProfPic.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
