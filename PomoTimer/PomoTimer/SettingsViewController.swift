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
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Display"
        case 1:
            return "Sound"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "darkModeCell") as? DarkModeTableViewCell {
                    cell.darkMode = self.darkMode
                    return cell
                } else {
                    return UITableViewCell()
                }
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "buttonSoundCell") as? ButtonSoundTableViewCell {
                    return cell
                } else {
                    return UITableViewCell()
                }
            case 1:
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "alarmSoundCell") as? AlarmSoundTableViewCell {
                    return cell
                } else {
                    return UITableViewCell()
                }
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        delegate?.didTapDoneButton()
    }
    
    @IBAction func didTapDarkModeSwitch(_ sender: Any) {
        delegate?.didTapDarkModeSwitch()
    }
}
