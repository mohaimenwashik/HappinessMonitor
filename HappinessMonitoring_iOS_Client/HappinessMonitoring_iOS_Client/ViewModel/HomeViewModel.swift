//
//  HomeViewModel.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/24/25.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var isSubscribed = false
    @Published var surveys: [Survey] = []
    @Published var message: String = ""

    @AppStorage("userId") private var userId: Int = 0
    @AppStorage("deviceToken") var deviceToken: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

    init() {
        registerUser()
    }

    func registerUser() {
        NetworkManager.shared.registerUser(deviceToken: deviceToken) { user in
            if let user = user {
                self.userId = user.id
                self.isSubscribed = user.is_subscribed
                self.fetchSurveys()
            } else {
                // fallback if already exists
                NetworkManager.shared.fetchUser(deviceToken: self.deviceToken) { user in
                    if let user = user {
                        self.userId = user.id
                        self.isSubscribed = user.is_subscribed
                        self.fetchSurveys()
                    } else {
                        self.message = "Failed to register or fetch user."
                    }
                }
            }
        }
    }

    func fetchSurveys() {
        NetworkManager.shared.fetchSurveys(deviceToken: deviceToken) { surveys in
            self.surveys = surveys
        }
    }

    func toggleSubscription(completion: @escaping () -> Void) {
        NetworkManager.shared.toggleSubscription(deviceToken: deviceToken) { updatedStatus in
            DispatchQueue.main.async {
                completion()
                if let status = updatedStatus {
                    self.isSubscribed = status
                    self.message = status ? "Subscribed to prompts." : "Unsubscribed from prompts."

                    if status {
                        NotificationManager.shared.scheduleMinuteReminder()
                    } else {
                        NotificationManager.shared.cancelReminders()
                    }
                } else {
                    self.message = "Failed to update subscription."
                }
            }
        }
    }
}
