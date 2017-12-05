//
//  ColorUIView.swift
//  ColorLab
//
//  Created by MikhailB on 06/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class ColorUIView: UIView {
    
    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}
