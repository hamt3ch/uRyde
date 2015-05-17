//
//  TableCell.swift
//  uRyde
//
//  Created by Peyt Spencer Dewar on 5/17/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var destination: UILabel!
    @IBOutlet var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
