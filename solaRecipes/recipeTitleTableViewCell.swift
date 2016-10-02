//
//  recipeTitleTableViewCell.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/24/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit

class recipeTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
