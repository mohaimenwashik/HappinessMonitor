//
//  Endpoints.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import Foundation

struct API {
    static let baseURL = "http://127.0.0.1:8000/api"

    static let register = "\(baseURL)/register/"
    static let submitSurvey = "\(baseURL)/submit/"
    static func latestSurveys(for deviceToken: String) -> String {
        return "\(baseURL)/latest/\(deviceToken)/"
    }
    static let toggleSubscription = "\(baseURL)/toggle-subscription/"
}

