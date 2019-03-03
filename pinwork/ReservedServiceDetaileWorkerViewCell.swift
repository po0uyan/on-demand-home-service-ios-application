//
//  ServiceDetailWorkerViewCell.swift
//  pinwork
//
//  Created by pouyan shalbafan on 2/16/19.
//  Copyright © 2019 Pouyan. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Lottie
class ReservedServiceDetaileWorkerViewCell: UITableViewCell {
    let lottieSearchAnimation = LOTAnimationView(name: "search-app")
    var defaultColor : CGColor = UIColor.white.cgColor
    
    @IBOutlet weak var workerImage: UIImageView!
    
    @IBOutlet weak var workerRatingStarView: HCSStarRatingView!
    
    @IBOutlet weak var workerFullNameLabel: UILabel!
    
    @IBOutlet weak var workerRateNumberLabel: UILabel!
    
    @IBOutlet weak var showWorkerProfileButton: UIButton!
    

    @IBOutlet weak var searchingAnimationView: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        workerImage.layer.borderWidth = 3.0
        workerImage.layer.masksToBounds = true
        workerImage.layer.borderColor = UIColor(red:0.29, green:0.85, blue:0.77, alpha:1.0).cgColor
        workerImage.layer.cornerRadius = workerImage.frame.height / 2
        showWorkerProfileButton.layer.cornerRadius = 8
        showWorkerProfileButton.layer.shadowColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0).cgColor
        showWorkerProfileButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        showWorkerProfileButton.layer.shadowRadius = 2
        showWorkerProfileButton.layer.shadowOpacity = 0.5
        lottieSearchAnimation.frame = CGRect(x: self.searchingAnimationView.frame.origin.x, y: self.searchingAnimationView.frame.origin.y, width: self.searchingAnimationView.frame.width, height: self.searchingAnimationView.frame.height)
        lottieSearchAnimation.center = self.searchingAnimationView.center
        lottieSearchAnimation.contentMode = .scaleAspectFit
        
        self.addSubview(lottieSearchAnimation)
        
        lottieSearchAnimation.play()
        lottieSearchAnimation.loopAnimation = true
        defaultColor = self.contentView.layer.backgroundColor!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
showWorkerProfileButton.layer.backgroundColor = UIColor(red:0.32, green:0.85, blue:0.81, alpha:1.0).cgColor
        
        // Configure the view for the selected state
    }

}
