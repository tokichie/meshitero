//
//  CustomTableViewCell.swift
//  Meshitero
//
//  Created by 時武佑太 on 2014/09/28.
//  Copyright (c) 2014年 Yuta Tokitake. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var imageOwnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
