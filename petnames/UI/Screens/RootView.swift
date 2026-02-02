//
//  RootView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState.shared
    @StateObject private var sessionManager = SessionManager.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showNotificationPermission = false
    
    // Track if we've shown the notification screen
    @AppStorage("hasShownNotificationPermission") private var hasShownNotificationPermission = false
    
    var body: some View {
        Group {
            if isLoading {
                loadingView
            } else if showNotificationPermission {
                NotificationPermissionView {
                    withAnimation {
                        hasShownNotificationPermission = true
                        showNotificationPermission = false
                    }
                }
                .transition(.opacity)
            } else if appState.isOnboarded {
                HomeSwipeView()
            } else {
                OnboardingView()
            }
        }
        .task {
            await initializeApp()
        }
        .onChange(of: appState.isOnboarded) { _, isOnboarded in
            // Show notification permission after onboarding completes
            if isOnboarded && !hasShownNotificationPermission && !notificationManager.isAuthorized {
                withAnimation {
                    showNotificationPermission = true
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
    }
    
    private var loadingView: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1D94DB"), Color(hex: "67F1D1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App Icon
                Image("petnamesLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(spacing: 4) {
                    Text("Petnames")
                        .font(.custom("Poppins-Bold", size: 36))
                        .foregroundStyle(.white)
                    
                    Text("by Kinder")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)
                    .padding(.top, 16)
            }
        }
    }
    
    private func initializeApp() async {
        do {
            // Sign in anonymously
            try await sessionManager.signInAnonymouslyIfNeeded()
            
            // Load app state from defaults
            appState.loadFromDefaults()
            
            // Check notification authorization status
            await notificationManager.checkAuthorizationStatus()
            
            // Small delay for splash screen effect
            try? await Task.sleep(for: .milliseconds(500))
            
            isLoading = false
            
            // If already onboarded and haven't shown notification permission yet
            if appState.isOnboarded && !hasShownNotificationPermission && !notificationManager.isAuthorized {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showNotificationPermission = true
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isLoading = false
        }
    }
}

#Preview {
    RootView()
}
