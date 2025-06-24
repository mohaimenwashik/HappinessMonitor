//
//  NetworkManager.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import Foundation

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func registerUser(deviceToken: String, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: API.register) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["device_token": deviceToken]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("✅ Register User Response:")
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                let user = try? JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(user)
                }
            } else {
                print("❌ Failed to register user: \(error?.localizedDescription ?? "No data")")
                completion(nil)
            }
        }.resume()
    }

    func fetchSurveys(deviceToken: String, completion: @escaping ([Survey]) -> Void) {
        guard let url = URL(string: API.latestSurveys(for: deviceToken)) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("📥 Latest Surveys Response:")
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                let surveys = (try? JSONDecoder().decode([Survey].self, from: data)) ?? []
                DispatchQueue.main.async {
                    completion(surveys)
                }
            } else {
                print("❌ Failed to fetch surveys: \(error?.localizedDescription ?? "No data")")
                completion([])
            }
        }.resume()
    }

    func submitSurvey(survey: Survey, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: API.submitSurvey) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(survey)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("📤 Submit Survey Response:")
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            } else {
                print("❌ Failed to submit survey: \(error?.localizedDescription ?? "No data")")
            }

            DispatchQueue.main.async {
                completion(response != nil && error == nil)
            }
        }.resume()
    }

    func toggleSubscription(deviceToken: String, completion: @escaping (Bool?) -> Void) {
        guard let url = URL(string: API.toggleSubscription) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["device_token": deviceToken]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("🔁 Toggle Subscription Response:")
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                let result = try? JSONDecoder().decode([String: Bool].self, from: data)
                DispatchQueue.main.async {
                    completion(result?["subscribed"])
                }
            } else {
                print("❌ Failed to toggle subscription: \(error?.localizedDescription ?? "No data")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchUser(deviceToken: String, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: API.baseURL + "/user/\(deviceToken)/") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let user = try? JSONDecoder().decode(User.self, from: data)
            DispatchQueue.main.async {
                completion(user)
            }
        }.resume()
    }
}
