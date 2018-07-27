//
//  MenuTableViewCell.swift
//  pinwork
//
//  Created by Pouyan on 7/13/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageItem: UIImageView!
    
    @IBOutlet weak var menuTextItem: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
