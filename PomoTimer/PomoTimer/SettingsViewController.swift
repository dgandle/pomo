//
//  SettingsViewController.swift
//  PomoTimer
//
//  Created by Douglas Gandle on 10/27/17.
//  Copyright © 2017 Doug Gandle. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func didTapDoneButton()
}

class SettingsViewController: UIViewController {

    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // trigger delegate to dismiss VC
        delegate?.didTapDoneButton()
    }
    
}
