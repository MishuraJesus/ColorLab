//
//  RGBColorUITextField.swift
//  ColorLab
//
//  Created by MikhailB on 01/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit



class RGBColorUITextField: UITextField {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
