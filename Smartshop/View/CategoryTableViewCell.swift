//
//  CategoryTableViewCell.swift
//  Smartshop
//
//  Created by Shunchao Wang on 1/26/2016.
//  Copyright © 2016 swang. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var categoryId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
