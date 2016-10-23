//
//  RoutesTableViewCell.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 11/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell {

    @IBOutlet weak var routeTitleLbl: UILabel!
    @IBOutlet weak var routeDescriptionLbl: UILabel!
    @IBOutlet weak var routePointsLbl: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
