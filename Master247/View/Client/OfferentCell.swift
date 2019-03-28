//
//  OfferentCell.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/27/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit

class OfferentCell: UITableViewCell {

    @IBOutlet weak var offerentNameAndLastnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(offerents: Offerent) {
        offerentNameAndLastnameLabel.text = offerents.nameAndLastname
    }

}
