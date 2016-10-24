//
//  advancedSearchTableViewCell.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/23/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit

class advancedSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var durationSlider: UISlider!
    
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var fromTempTextField: UITextField!
    
    @IBOutlet weak var toTempTextField: UITextField!
    
    @IBOutlet weak var tagsTableView: UITableView!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        durationSlider.minimumValue = -20
        durationSlider.maximumValue = 120
        durationSlider.isContinuous = false
        
        weightSlider.minimumValue = 5
        weightSlider.maximumValue = 100
        weightSlider.isContinuous = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
