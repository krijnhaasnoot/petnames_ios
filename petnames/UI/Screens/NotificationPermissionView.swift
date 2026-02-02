//
//  NotificationPermissionView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct NotificationPermissionView: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    let onComplete: () -> Void
    
    @State private var isRequesting = false
    
    private let gradientColors = [Color(hex: "34CDD2"), Color(hex: "1C95DC")]
    
    var body: some View {
        ZStack {
            // White background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Heart icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ).opacity(0.15)
                        )
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ).opacity(0.25)
                        )
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(hex: "FF2C55"))
                        .symbolEffect(.bounce, options: .repeating.speed(0.5))
                }
                
                // Title
                VStack(spacing: 12) {
                    Text("Blijf op de hoogte!")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Mis geen match")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                // Benefits list
                VStack(alignment: .leading, spacing: 16) {
                    NotificationBenefit(
                        icon: "heart.fill",
                        iconColor: Color(hex: "FF2C55"),
                        text: "Weet direct wanneer jullie een naam matchen"
                    )
                    
                    NotificationBenefit(
                        icon: "person.badge.plus",
                        iconColor: Color(hex: "1C95DC"),
                        text: "Zie wanneer iemand je household joint"
                    )
                    
                    NotificationBenefit(
                        icon: "sparkles",
                        iconColor: Color(hex: "1C95DC"),
                        text: "Ontvang leuke updates over nieuwe namen"
                    )
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button {
                        requestPermission()
                    } label: {
                        HStack(spacing: 8) {
                            if isRequesting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "bell.fill")
                            }
                            Text("Notificaties inschakelen")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(hex: "1C95DC"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "1C95DC").opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isRequesting)
                    
                    Button {
                        skipPermission()
                    } label: {
                        Text("Misschien later")
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: "1C95DC"))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Track permission screen shown
            AnalyticsManager.shared.trackNotificationPermissionShown()
        }
    }
    
    private func requestPermission() {
        isRequesting = true
        
        Task {
            await notificationManager.requestPermission()
            
            await MainActor.run {
                isRequesting = false
                
                // Track permission result
                if notificationManager.isAuthorized {
                    AnalyticsManager.shared.trackNotificationPermissionGranted()
                } else {
                    AnalyticsManager.shared.trackNotificationPermissionDenied()
                }
                
                // Small delay so user sees the result
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
    
    private func skipPermission() {
        // Track skipped as denied
        AnalyticsManager.shared.trackNotificationPermissionDenied()
        onComplete()
    }
}

// MARK: - Benefit Row

struct NotificationBenefit: View {
    let icon: String
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    NotificationPermissionView {
        print("Completed")
    }
}
