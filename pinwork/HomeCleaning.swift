//
//  HomeCleaning.swift
//  pinwork
//
//  Created by Pouyan on 6/9/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class HomeCleaning: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {

        return self.loadFromNibIfEmbeddedInDifferentNib()
    }

}
