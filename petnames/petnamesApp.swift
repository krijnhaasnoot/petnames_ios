//
//  petnamesApp.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI
import UIKit
import UserNotifications

@main
struct petnamesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // DEBUG: Print all available fonts to find the correct Poppins name
        printAvailableFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    /// Debug function to print all available font names
    private func printAvailableFonts() {
        print("🔤 === AVAILABLE FONTS ===")
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            if !names.isEmpty {
                if family.lowercased().contains("poppins") {
                    print("📦 Family: \(family)")
                    for name in names {
                        print("   ✅ Font name: \"\(name)\"")
                    }
                }
            }
        }
        print("🔤 === END FONTS ===")
    }
}

// MARK: - App Delegate for Push Notifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // MARK: - Remote Notification Registration
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleDeviceToken(deviceToken)
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleRegistrationError(error)
        }
    }
    
    // MARK: - Notification Center Delegate
    
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show push notification even when app is in foreground
        // This is for OTHER household members who didn't trigger the match
        // (The person who triggers the match is excluded from receiving the push via exclude_user_id)
        completionHandler([.banner, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle different notification types
        if let type = userInfo["type"] as? String {
            switch type {
            case "match":
                // Navigate to matches
                print("📱 User tapped match notification")
            case "new_member":
                // Navigate to profile/household
                print("📱 User tapped new member notification")
            default:
                break
            }
        }
        
        completionHandler()
    }
}
