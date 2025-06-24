//
//  SurveyView.swift
//  HappinessMonitoring_iOS_Client
//
//  Created by Mohaimen Washik on 6/23/25.
//

import Foundation
import SwiftUI

struct SurveyView: View {
    @AppStorage("userId") private var userId: Int = 0

    let deviceToken: String
    let isSubscribed: Bool
    let pauseReminders: () -> Void
    var onSubmit: () -> Void
    

    @Environment(\.dismiss) var dismiss

    @State private var activity = ""
    @State private var happiness = 5
    @State private var showMessage = false
    @State private var message = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 25) {
                    Text("What is your activity now?")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("e.g. Studying, Cooking...", text: $activity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("How happy are you feeling right now?")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Slider(value: Binding(get: {
                        Double(happiness)
                    }, set: {
                        happiness = Int($0)
                    }), in: 1...10, step: 1)
                    
                    Text("Happiness Level: \(happiness)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if showMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Button("Cancel") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            dismiss()
                        }
                        .disabled(isSubmitting)
                        .foregroundColor(isSubmitting ? .gray : .red)
                        
                        Spacer()
                        
                        Button("Submit") {
                            submitSurvey()
                        }
                        .disabled(activity.isEmpty || isSubmitting)
                        .foregroundColor((activity.isEmpty || isSubmitting) ? .gray : .blue)
                    }
                }
                .padding()
                .navigationTitle("Survey")
                .opacity(isSubmitting ? 0.3 : 1.0)
                
                if isSubmitting {
                    ProgressView("Submitting...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
    }

    // MARK: - Submit Survey to API
    func submitSurvey() {
        isSubmitting = true
        let survey = Survey(id: 0, user: userId, activity: activity, happiness: happiness, created_at: "")
        
        NetworkManager.shared.submitSurvey(survey: survey) { success in
            isSubmitting = false
            if success {
                message = "Survey submitted successfully!"
                showMessage = true

                if isSubscribed {
                    pauseReminders()
                }

                onSubmit()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    dismiss()
                }
            } else {
                message = "Failed to submit survey."
                showMessage = true
            }
        }
    }

}


