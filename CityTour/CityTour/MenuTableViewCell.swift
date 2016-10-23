//
//  MenuTableViewCell.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 10/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
