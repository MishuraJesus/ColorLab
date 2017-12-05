//
//  ViewController.swift
//  ColorLab
//
//  Created by MikhailB on 16/11/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var hexView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - TextFieldAnimation
    func animateTextField(up: Bool)
    {
        let movementDistance : Int = -Int(200)
        let movementDuration : Double = 0.2
        let movement : Int = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(up: false)
        
        guard let text = textField.text else { return }
        
        if text == "" {
            textField.text = "\(0)"
            
            switch textField {
            case redTextField:
                redSlider.value = Float(textField.text!)!
            case greenTextField:
                greenSlider.value = Float(textField.text!)!
            case blueTextField:
                blueSlider.value = Float(textField.text!)!
            default: return
            }
            
            colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1.0)
            hexTextField.text = colorView.backgroundColor!.toHexString
            hexView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 0.2)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - IBAction
    @IBAction func rgbSliderValueChanged(sender: AnyObject) {
        guard let slider = sender as? UISlider else { return }
        
        switch slider {
        case redSlider: redTextField.text = "\(Int(slider.value))"
        case greenSlider: greenTextField.text = "\(Int(slider.value))"
        case blueSlider: blueTextField.text = "\(Int(slider.value))"
        default: return
        }
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1.0)
        hexTextField.text = colorView.backgroundColor!.toHexString
        hexView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 0.2)
    }
    
    @IBAction func rgbTextFieldEditingChanged(sender: AnyObject) {
        guard let textField = sender as? UITextField else { return }
        guard let text = textField.text else { return }
        guard let value = Int(text) else { return }
        
        textField.text = value > 255 ? "\(255)" : "\(value)"
        
        switch textField {
        case redTextField:
            redSlider.value = Float(textField.text!)!
        case greenTextField:
            greenSlider.value = Float(textField.text!)!
        case blueTextField:
            blueSlider.value = Float(textField.text!)!
            default: return
        }
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1.0)
        hexTextField.text = colorView.backgroundColor!.toHexString
        hexView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 0.2)
    }
    
}

