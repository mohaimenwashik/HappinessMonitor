//
//  NotificationManager.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/24/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("[🔐] Notification permission granted: \(granted)")
        }
    }

    func scheduleMinuteReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["survey_reminder"])
        print("[🔔] Scheduling repeating notification every 60s")

        let content = UNMutableNotificationContent()
        content.title = "Happiness Check-In"
        content.body = "Ready for your next quick survey?"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let request = UNNotificationRequest(identifier: "survey_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func pauseRemindersFor2Minutes() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["survey_reminder"])
        print("[⏸️] Paused reminders after survey. Will resume in 5s...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("[🔄] Resuming reminders after pause")
            self.scheduleMinuteReminder()
        }
    }

    func cancelReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["survey_reminder"])
        print("[❌] All notifications canceled")
    }
}
