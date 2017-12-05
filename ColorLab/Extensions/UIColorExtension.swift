//
//  UIColorExtension.swift
//  ColorLab
//
//  Created by MikhailB on 02/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}
