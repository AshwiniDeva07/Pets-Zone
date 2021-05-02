//
//  PetsCategoryCollectionViewCell.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class PetsCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var petCategoryView: UIView!
    @IBOutlet var petsCategoryImageView: UIImageView!
    @IBOutlet var petsCategoryName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
