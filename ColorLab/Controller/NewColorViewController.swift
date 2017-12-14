//
//  ViewController.swift
//  ColorLab
//
//  Created by MikhailB on 16/11/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit
import Toast_Swift

class NewColorViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var hexView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    var textFieldTag: Int! // TextField tag: 0 - red, 1 - greeen, 2 - blue
    
    var hexValueIsCorrect = true { // If hexTextField text consists only from hex letter - true, else - false
        didSet {
            if hexValueIsCorrect {
                hexView.layer.borderWidth = 0
            } else {
                hexView.layer.borderWidth = 1
                hexView.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexTextField.delegate = self
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        let tapHideKeyboard: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        
        view.addGestureRecognizer(tapHideKeyboard)
        
        let tapShowFullColor: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFullColor))
        colorView.addGestureRecognizer(tapShowFullColor)
        
        addDoneButtonOnKeyboard()
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Show Full Color
    @objc func showFullColor() {
        performSegue(withIdentifier: "showColor", sender: nil)
    }
    
    //MARK: - Done Button
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.redTextField.inputAccessoryView = doneToolbar
        self.greenTextField.inputAccessoryView = doneToolbar
        self.blueTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        switch textFieldTag {
        case 0: redTextField.resignFirstResponder()
        case 1: greenTextField.resignFirstResponder()
        case 2: blueTextField.resignFirstResponder()
        default: break
        }
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
        // Check that textField is not the hexTextField not to invoke animation
        if (textField != hexTextField) {
        
        self.animateTextField(up: true)
        
        switch textField {
            case redTextField: textFieldTag = 0
            case greenTextField: textFieldTag = 1
            case blueTextField: textFieldTag = 2
            default: return
        }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
//        if textField == hexTextField {
//            if (!hexValueIsCorrect) {
//                hexView.layer.borderWidth = 1
//                hexView.layer.borderColor = UIColor.red.cgColor
//
//        }
//        }
        // Check that textField is not the hexTextField not to do animation related stuff
        if (textField != hexTextField) {
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showColor", let controller = segue.destination as? FullColorViewController {
            controller.color = colorView.backgroundColor!
        }
    }
    
    //MARK: - IBAction
    @IBAction func copyButtonTapped(sender: Any) {
        
        if let button = sender as? UIButton {
            button.backgroundColor = UIColor.white
        }
        
        if !hexValueIsCorrect {
            
            let alertController = UIAlertController(title: "Invalid Hex Value", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            show(alertController, sender: nil)
            
        }
        
        guard let text = hexTextField.text else { return }
        
        UIPasteboard.general.string = "#\(text)"
        
        self.view.makeToast("HEX Copied", duration: 2.0, point: CGPoint(x: self.view.bounds.size.width / 2.0, y: hexView.frame.maxY + 30.0), title: nil, image: nil, style: ToastStyle(), completion: nil)
        
    }
    
    @IBAction func copyButtonHoldDown(sender: Any) {
        if let button = sender as? UIButton {
            button.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 232/255, alpha: 1)
        }
    }
    
    @IBAction func copyButtonTouchDragOutside(sender: Any)
    {
        if let button = sender as? UIButton {
            button.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func rgbSliderValueChanged(sender: Any) {
        guard let slider = sender as? UISlider else { return }
        
        hexValueIsCorrect = true
        
        // Update color textField value
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
    
    @IBAction func rgbTextFieldEditingChanged(sender: Any) {
        guard let textField = sender as? UITextField else { return }
        guard let text = textField.text else { return }
        guard let value = Int(text) else { return }
        
        hexValueIsCorrect = true
        
        // For comfort if user inputs value bigger than '255' just set it to be '255'
        textField.text = value > 255 ? "\(255)" : "\(value)"
        
        // Update color slider value
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
    
    @IBAction func hexTextFieldEditingChanged(sender: Any) {
        guard let textField = sender as? UITextField else { return }
        guard let text = textField.text else { return }
        
        
        // Algorithm: Checks that the user input consists of only hex letters like '0123456789abcdef'
        // Perform updating of all values only if number of occurences is 6
        if text.count == 6 {
            let hexLetters = "0123456789abcdef"
            var occurenceNumber = 0
            for letter in text.lowercased() {
                for hexLetter in hexLetters {
                    if letter == hexLetter {
                        occurenceNumber += 1
                    }
                }
            }
            // Update all values
            if occurenceNumber == 6 {
                hexValueIsCorrect = true
                hexView.layer.borderWidth = 0
                
                let color = UIColor.color(fromHexString: text)
                colorView.backgroundColor = color
                print(color.toHexString)
                
                let red = Int(color.redValue * 255)
                let green = Int(color.greenValue * 255)
                let blue = Int(color.blueValue * 255)
                
                redSlider.value = Float(red)
                greenSlider.value = Float(green)
                blueSlider.value = Float(blue)
                
                redTextField.text = "\(red)"
                greenTextField.text = "\(green)"
                blueTextField.text = "\(blue)"
                
                hexView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 0.2)
            } else {
                hexValueIsCorrect = false
            }
        } else if text.count > 6 {
            hexValueIsCorrect = false
        }
    }
    
    @IBAction func randomButtonPressed(sender: Any) {
        hexValueIsCorrect = true
        
        let red = Int(arc4random_uniform(256))
        let green = Int(arc4random_uniform(256))
        let blue = Int(arc4random_uniform(256))
        
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        
        redTextField.text = "\(red)"
        greenTextField.text = "\(green)"
        blueTextField.text = "\(blue)"
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1)
        hexTextField.text = colorView.backgroundColor!.toHexString
        hexView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 0.2)
    }
}

