//
//  LocalNotificationManager.swift
//  MediTracker
//
//  Created by Trupti on 11/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification{
    var title:String
    var message:String
    var dateAndTime:DateComponents
}

class LocalNotificationManager {
    var localNotifications = [Notification]()
    
    
    func getLocalNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            for notification in notifications{
                debugPrint(notification)
            }
        }
    }


    private func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (allow, error) in
            if allow{
                //schedule notifications
                
            }else{
                debugPrint("Use declined notification access")
            }
        }
    }


    func checkSettingAndSchedule(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus{
                
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            case .denied:
                break
            @unknown default:
                break
            }
        }
    }
    
    
    // MARK: Local Notification scheduler
    private func scheduleNotifications() {
        
        for notification in localNotifications{
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.message
            content.badge = 1
            content.sound = .default
            content.categoryIdentifier = "alarm"
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateAndTime, repeats: false)
            
            let request = UNNotificationRequest(identifier: notification.title, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                guard error == nil else{
                    return
                }
                
                debugPrint("Notification scheduled successfully! \(notification.title)")
            }
        }
        
        
    }
}
