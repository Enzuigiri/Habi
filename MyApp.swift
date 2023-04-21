//
//  HabiApp.swift
//  Habi
//
//  Created by Enzu Ao on 14/04/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}


@main
struct HabiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = appDelegate
        center.requestAuthorization(options: [.alert,.sound,.badge]) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
