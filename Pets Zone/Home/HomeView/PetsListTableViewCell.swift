//
//  PetsListTableViewCell.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class PetsListTableViewCell: UITableViewCell {
    
    
    @IBOutlet var petsListMainView: UIView!
    
    @IBOutlet var petsPhotoView: UIView!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var petsDetailView: UIView!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var pinButton: UIButton!
    
    @IBOutlet var petsStackView: UIStackView!
    @IBOutlet var petTypeName: UILabel!
    @IBOutlet var petYearLabel: UILabel!
    @IBOutlet var petDistanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
