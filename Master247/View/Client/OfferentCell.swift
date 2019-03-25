//
//  OfferentCell.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/21/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Kingfisher

class OfferentCell: UITableViewCell {

    @IBOutlet weak var offerentNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


//    func configureCell(workers: Worker) {
//        offerentNameLabel.text = workers.nameAndLastname
//        if let url = URL(string: workers.profileImageURL) {
//            profileImage.kf.setImage(with: url)
//        }
//    }
    

}
