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
    func didTapDarkModeSwitch()
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SettingsDelegate?
    var darkMode: Bool?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "darkModeCell") as? DarkModeTableViewCell {
            cell.darkMode = self.darkMode
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        // trigger delegate to dismiss VC
        delegate?.didTapDoneButton()
    }
    
    @IBAction func didTapDarkModeSwitch(_ sender: Any) {
        delegate?.didTapDarkModeSwitch()
    }
}
