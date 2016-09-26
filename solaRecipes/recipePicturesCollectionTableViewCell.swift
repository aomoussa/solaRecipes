//
//  recipePicturesCollectionTableViewCell.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/24/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit

class recipePicturesCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.blueColor()
        
        return cell
        
    }
}
