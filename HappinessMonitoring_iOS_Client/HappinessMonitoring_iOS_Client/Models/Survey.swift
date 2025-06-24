//
//  Survey.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import Foundation

struct Survey: Codable, Identifiable {
    let id: Int
    let user: Int
    let activity: String
    let happiness: Int
    let created_at: String
}
