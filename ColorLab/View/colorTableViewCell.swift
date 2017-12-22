//
//  colorTableViewCell.swift
//  ColorLab
//
//  Created by Mikhail Bobretsov on 21/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class colorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var rgbLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 20
        colorView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
