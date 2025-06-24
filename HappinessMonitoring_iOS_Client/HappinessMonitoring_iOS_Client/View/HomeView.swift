//
//  ContentView.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var notifVM = NotificationSettingsViewModel()
    @State private var showSurvey = false
    @State private var isLoading = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    // Toggle Subscription
                    Button(action: {
                        isLoading = true
                        viewModel.toggleSubscription {
                            notifVM.isSubscribed = viewModel.isSubscribed
                            isLoading = false
                        }
                    }) {
                        Text(viewModel.isSubscribed ? "Unsubscribe to Prompts" : "Subscribe to Prompts")
                            .padding()
                            .background(viewModel.isSubscribed ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    // Take Survey Button
                    Button(action: {
                        showSurvey = true
                    }) {
                        Text("Take Survey")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showSurvey) {
                        SurveyView(
                            deviceToken: viewModel.deviceToken,
                            isSubscribed: viewModel.isSubscribed,
                            pauseReminders: {
                                notifVM.pauseAfterSurvey()
                            },
                            onSubmit: {
                                viewModel.fetchSurveys()
                            }
                        )
                    }

                    // Display message
                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    Divider()

                    // Last 3 surveys
                    Text("Last 3 Surveys")
                        .font(.headline)

                    List(viewModel.surveys) { survey in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Activity: \(survey.activity)")
                            Text("Happiness: \(survey.happiness)")
                            Text("Date: \(survey.created_at.prefix(16).replacingOccurrences(of: "T", with: " "))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .navigationTitle("Happiness Monitor")

                if isLoading {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
            viewModel.registerUser()
        }
    }
}

#Preview {
    HomeView()
}
