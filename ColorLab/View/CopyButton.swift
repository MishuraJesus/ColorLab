//
//  CopyButton.swift
//  ColorLab
//
//  Created by Mikhail Bobretsov on 14/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class CopyButton: UIButton {

    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }

}
