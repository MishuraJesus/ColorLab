//
//  FullColorViewController.swift
//  ColorLab
//
//  Created by Mikhail Bobretsov on 14/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit

class FullColorViewController: UIViewController {
    
    @IBOutlet weak var fullColorView: UIView!
    
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullColorView.backgroundColor = color!
        
        let tapGoBack: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        fullColorView.addGestureRecognizer(tapGoBack)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func goBack() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
