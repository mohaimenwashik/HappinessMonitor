//
//  User.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import Foundation

struct User: Codable {
    let id: Int
    let device_token: String
    let is_subscribed: Bool
    let created_at: String
}
