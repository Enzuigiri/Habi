//
//  Notification.swift
//  Habi
//
//  Created by Enzu Ao on 14/04/23.
//

import SwiftUI
import UserNotifications

//enum NotificationAction: String {
//    case dismiss
//    case reminder
//}
//
//enum NotificationCategory: String {
//    case general
//}
//
//class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//
//        print(userInfo)
//        completionHandler()
//
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner,.sound,.badge])
//    }
//}

struct HabiNotification {
    func scheduleDailyNotification(notificationTime: Date, id: String, habit: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Routine Reminder"
        content.body = "\(habit) routine is up, don't forget to do it 🤩"
        content.sound = .default
        
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
       
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
      
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(notificationTime)")
            }
        }
    }
    
    func removeScheduledNotification(id: String) {
      UNUserNotificationCenter.current()
        .removePendingNotificationRequests(withIdentifiers: [id])
    }
}

//struct NotificationView: View {
//    var test = "ABC" {
//        didSet {
//            print("hello")
//        }
//    }
//    var body: some View {
//        VStack {
//            Button("Schedule Notification") {
//                let center = UNUserNotificationCenter.current()
//                let content = UNMutableNotificationContent()
//
//                content.title = "Testing"
//                content.subtitle = "This is subtitle"
//                content.body = "The early bird catches the worm, but the second mouse gets the cheese."
//                content.categoryIdentifier = NotificationCategory.general.rawValue
//                content.userInfo = ["customData": "fizzBuzz"]
//                content.sound = UNNotificationSound.default
//
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                let request = UNNotificationRequest(identifier: "Warming Up", content: content, trigger: trigger)
//
//                let dsimiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss", options: [])
//                let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
//                let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dsimiss, reminder], intentIdentifiers: [], options: [])
//
//                center.setNotificationCategories([generalCategory ])
//
//                center.add(request) { error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//       NotificationView()
//    }
//}
