//
//  NotificationSettingsViewModel.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/24/25.
//

import Foundation

class NotificationSettingsViewModel: ObservableObject {
    @Published var isSubscribed: Bool {
        didSet {
            UserDefaults.standard.set(isSubscribed, forKey: "is_subscribed")

            if isSubscribed {
                NotificationManager.shared.scheduleMinuteReminder()
            } else {
                NotificationManager.shared.cancelReminders()
            }
        }
    }

    init() {
        // Load saved subscription status or default to false
        self.isSubscribed = UserDefaults.standard.bool(forKey: "is_subscribed")
    }

    func pauseAfterSurvey() {
        if isSubscribed {
            NotificationManager.shared.pauseRemindersFor2Minutes()
        }
    }
}
