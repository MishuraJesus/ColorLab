//
//  ViewController.swift
//  ColorLab
//
//  Created by MikhailB on 16/11/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        text1.delegate = self
        text2.delegate = self
        text3.delegate = self
    }
    
    func animateTextField(textField: UITextField, up: Bool, withOffset offset:CGFloat)
    {
        let movementDistance : Int = -Int(200)
        let movementDuration : Double = 0.2
        let movement : Int = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        //self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement))
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up: true, withOffset: textField.frame.origin.y / 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up: false, withOffset: textField.frame.origin.y / 2)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}

