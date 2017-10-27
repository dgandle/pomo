//
//  TimerViewController.swift
//  PomoTimer
//
//  Created by Doug Gandle on 8/25/17.
//  With help from user Rob 
//  at https://stackoverflow.com/questions/34496389/swift-nstimer-in-background
//  Copyright © 2017 Doug Gandle. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class TimerViewController: UIViewController, SettingsDelegate {

    enum State {
        case start
        case active
        case paused
        case rest
    }
    
    var currentState: State = .start
    var previousState: State?
    var isResetting = false
    var darkMode = false
    
    let systemSoundID: SystemSoundID = 1304
    let buttonSoundID: SystemSoundID = 1104
    
    private let activeTimeLength: Double = 1501
    private let restTimeLength: Double = 301
    
    // These are test values
//    private let activeTimeLength: Double = 10
//    private let restTimeLength: Double = 10
    
    private var startTime: Date?
    private var stopTime: Date?
    private var elapsedTime: Double = 0
    private var timer: Timer?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = timeString(time: TimeInterval(activeTimeLength - 1))
        updateButtons()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        registerForLocalNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func registerForLocalNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                guard granted && error == nil else {
                    // display error
                    print("\(String(describing: error))")
                    return
                }
            }
        } else {
            let types: UIUserNotificationType = [.badge, .sound, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    func updateButtons() {
        switch (currentState) {
        case .start:
            topButton.isEnabled = false
            bottomButton.setTitle("START", for: .normal)
            timeLabel.textColor = UIColor.black
            timeLabel.backgroundColor = UIColor.white
        case .active:
            topButton.isEnabled = true
            bottomButton.setTitle("PAUSE", for: .normal)
            timeLabel.textColor = UIColor.white
            timeLabel.backgroundColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        case .paused:
            topButton.isEnabled = true
            bottomButton.setTitle("RESUME", for: .normal)
            timeLabel.textColor = UIColor.white
            timeLabel.backgroundColor = UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.0)
        case .rest:
            topButton.isEnabled = true
            bottomButton.setTitle("PAUSE", for: .normal)
            timeLabel.textColor = UIColor.black
            timeLabel.backgroundColor = UIColor.white
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%01i:%02i", minutes, seconds)
    }
    
    @IBAction func bottomButtonTouchUpInside(_ sender: Any) {
        switch (currentState) {
        case .start:
            startTimer(withState: .active)
        case .active:
            pauseTimer()
        case .paused:
            resumeTimer()
        case .rest:
            pauseTimer()
        }
        handleTap()
        updateButtons()
    }
    
    @IBAction func topButtonTouchUpInside(_ sender: Any) {
        if (isResetting) {
            resetTimer()
        } else {
            topButton.setTitle("YOU SURE?", for: .normal)
            isResetting = true
        }
    }
    
    @IBAction func bottomButtonTouchDown(_ sender: Any) {
        AudioServicesPlaySystemSound(buttonSoundID)
    }
    
    @IBAction func topButtonTouchDown(_ sender: Any) {
        AudioServicesPlaySystemSound(buttonSoundID)
    }
    
    func handleTap() {
        if (isResetting) {
            topButton.setTitle("RESET", for: .normal)
            isResetting = false
        }
    }
    
    // MARK: Timer Functions
    
    private func startTimer(withState state: State) {
        var timeLength = activeTimeLength
        
        switch (state) {
        case .active:
            timeLength = activeTimeLength
            currentState = .active
        case .rest:
            timeLength = restTimeLength
            currentState = .rest
        default:
            break
        }
        
        self.startTime = Date()
        self.stopTime = Date().addingTimeInterval(timeLength)

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
        
        addNotification()
        
        }
    
    private func resumeTimer() {
        
        var timeLength = activeTimeLength
        
        if let prevState = previousState {
            switch (prevState) {
            case .active:
                timeLength = activeTimeLength
            case .rest:
                timeLength = restTimeLength
            default:
                timeLength = activeTimeLength
            }
            currentState = prevState
        } else {
            currentState = .active
        }
        
        self.startTime = Date()
        self.stopTime = Date().addingTimeInterval(timeLength-elapsedTime)

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
        
        addNotification()
        
        }
    
    private func pauseTimer() {
        if let start = startTime {
            elapsedTime += Date().timeIntervalSince(start)
            
            timer?.invalidate()
            removeAllNotifications()
            previousState = currentState
            currentState = .paused
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timeLabel.text = timeString(time: TimeInterval(activeTimeLength - 1))
        currentState = .start
        removeAllNotifications()
        updateButtons()
        topButton.setTitle("RESET", for: .normal)
        isResetting = false
    }
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let _formatter = DateComponentsFormatter()
        _formatter.allowedUnits = [.minute, .second]
        _formatter.unitsStyle = .positional
        _formatter.zeroFormattingBehavior = .pad
        return _formatter
    }()
    
    func handleTimer(_ timer: Timer) {
        let now = Date()
        updateButtons()
        if stopTime! > now {
            timeLabel.text = dateComponentsFormatter.string(from: now, to: stopTime!)
        } else {
            timer.invalidate()
            AudioServicesPlaySystemSound(systemSoundID)
            switch (currentState) {
            case .active:
                startTimer(withState: .rest)
            case .rest:
                startTimer(withState: .active)
            default:
                break
            }
        }
    }
    
    private func addNotification(includeNotification: Bool = true) {
        guard includeNotification else { return }
        
        // start local notification (so we're notified if timer expires while app is not running)
        
        // TODO: Update text, add handle for rest vs. active notification
        
        if #available(iOS 10, *) {
            let content = UNMutableNotificationContent()
            content.title = "Timer expired"
            content.body = "Whoo, hoo!"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: stopTime!.timeIntervalSinceNow, repeats: false)
            let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(notification)
        } else {
            let notification = UILocalNotification()
            notification.fireDate = stopTime
            notification.alertBody = "Timer finished!"
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    private func removeAllNotifications(includeNotification: Bool = true) {
        guard includeNotification else { return }
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.scheduledLocalNotifications?.removeAll()
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as? UINavigationController
        let destinationVC = navigationVC?.viewControllers.first as? SettingsViewController
        destinationVC?.delegate = self
        destinationVC?.darkMode = self.darkMode
    }
    
    
    // MARK: Delegate Methods
    
    func didTapDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapDarkModeSwitch() {
        self.darkMode = !self.darkMode
    }
}
