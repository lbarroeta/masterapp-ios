//
//  CategoryCell.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/20/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
        self.layer.cornerRadius = 5.0
        // Initialization code
    }
    
    func configureCell(categories: Category) {
        categoryTitle.text = categories.name
        if let url = URL(string: categories.imageURL) {
            categoryImage.kf.setImage(with: url)
        }
    }

}
