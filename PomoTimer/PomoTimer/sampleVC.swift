////
////  sampleVC.swift
////  PomoTimer
////
////  Created by Doug Gandle on 8/27/17.
////  Copyright © 2017 Doug Gandle. All rights reserved.
////
//
//import Foundation
//import UIKit
//import UserNotifications
//
//private let stopTimeKey = "stopTimeKey"
//
//class ViewController: UIViewController {
//    
//    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var timerLabel: UILabel!
//    
//    private var stopTime: Date?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        registerForLocalNotifications()
//        
//        stopTime = UserDefaults.standard.object(forKey: stopTimeKey) as? Date
//        if let time = stopTime {
//            if time > Date() {
//                startTimer(time, includeNotification: false)
//            } else {
//                notifyTimerCompleted()
//            }
//        }
//    }
//    
//    private func registerForLocalNotifications() {
//        if #available(iOS 10, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
//                guard granted && error == nil else {
//                    // display error
//                    print("\(error)")
//                    return
//                }
//            }
//        } else {
//            let types: UIUserNotificationType = [.badge, .sound, .alert]
//            let settings = UIUserNotificationSettings(types: types, categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//    }
//    
//    @IBAction func didTapStartButton(_ sender: AnyObject) {
//        let time = datePicker.date
//        if time > Date() {
//            startTimer(time)
//        } else {
//            timerLabel.text = "timer date must be in future"
//        }
//    }
//    
//    // MARK: Timer stuff
//    
//    private var timer: Timer?
//    
//    private func startTimer(_ stopTime: Date, includeNotification: Bool = true) {
//        // save `stopTime` in case app is terminated
//        
//        UserDefaults.standard.set(stopTime, forKey: stopTimeKey)
//        self.stopTime = stopTime
//        
//        // start Timer
//        
//        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
//        
//        guard includeNotification else { return }
//        
//        // start local notification (so we're notified if timer expires while app is not running)
//        
//        if #available(iOS 10, *) {
//            let content = UNMutableNotificationContent()
//            content.title = "Timer expired"
//            content.body = "Whoo, hoo!"
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: stopTime.timeIntervalSinceNow, repeats: false)
//            let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(notification)
//        } else {
//            let notification = UILocalNotification()
//            notification.fireDate = stopTime
//            notification.alertBody = "Timer finished!"
//            UIApplication.shared.scheduleLocalNotification(notification)
//        }
//    }
//    
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    private let dateComponentsFormatter: DateComponentsFormatter = {
//        let _formatter = DateComponentsFormatter()
//        _formatter.allowedUnits = [.hour, .minute, .second]
//        _formatter.unitsStyle = .positional
//        _formatter.zeroFormattingBehavior = .pad
//        return _formatter
//    }()
//    
//    // I'm going to use `DateComponentsFormatter` to update the
//    // label. Update it any way you want, but the key is that
//    // we're just using the scheduled stop time and the current
//    // time, but we're not counting anything. If you don't want to
//    // use `NSDateComponentsFormatter`, I'd suggest considering
//    // `NSCalendar` method `components:fromDate:toDate:options:` to
//    // get the number of hours, minutes, seconds, etc. between two
//    // dates.
//    
//    func handleTimer(_ timer: Timer) {
//        let now = Date()
//        
//        if stopTime! > now {
//            timerLabel.text = dateComponentsFormatter.string(from: now, to: stopTime!)
//        } else {
//            stopTimer()
//            notifyTimerCompleted()
//            
//        }
//    }
//    
//    private func notifyTimerCompleted() {
//        timerLabel.text = "Timer done!"
//    }
//    
//}
