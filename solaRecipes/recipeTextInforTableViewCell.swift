//
//  recipeTextInforTableViewCell.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/25/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit

class recipeTextInforTableViewCell: UITableViewCell {

    @IBOutlet weak var infoTypeLabel: UILabel!
    @IBOutlet weak var recipeInfoText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
