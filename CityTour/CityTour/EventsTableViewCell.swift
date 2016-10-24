//
//  EventsTableViewCell.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 24/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var lblNameEvent: UILabel!
    
    @IBOutlet weak var lblPlaceEvent: UILabel!
    
    @IBOutlet weak var lblDateEvent: UILabel!
    
    @IBOutlet weak var lblAddressEvent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
