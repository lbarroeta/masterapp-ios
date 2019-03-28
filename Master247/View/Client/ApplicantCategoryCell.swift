//
//  ApplicantCategoryCell.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/27/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit

class ApplicantCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categorySelectedMark: UIImageView!
    
    var showMark = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(categories: ApplicantCategory) {
        categoryTitle.text = categories.name
    }
    

}
