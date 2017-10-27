//
//  DarkModeTableViewCell.swift
//  PomoTimer
//
//  Created by Douglas Gandle on 10/27/17.
//  Copyright © 2017 Doug Gandle. All rights reserved.
//

import UIKit

class DarkModeTableViewCell: UITableViewCell {

    var darkMode: Bool?
    
    @IBOutlet weak var darkModeSwitch: UISwitch!

    override func layoutSubviews() {
        super.layoutSubviews()
        if let darkMode = self.darkMode {
            darkModeSwitch.setOn(darkMode, animated: true)
        }
    }
}
