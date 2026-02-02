//
//  NotificationManager.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI
import UserNotifications

/// Manages push notifications for the app
@MainActor
final class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var deviceToken: String?
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: - Request Permission
    
    func requestPermission() async {
        do {
            let center = UNUserNotificationCenter.current()
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            
            isAuthorized = granted
            
            if granted {
                // Register for remote notifications on main thread
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                print("✅ Push notifications authorized")
            } else {
                print("⚠️ Push notifications denied")
            }
        } catch {
            print("❌ Failed to request notification permission: \(error)")
        }
    }
    
    // MARK: - Check Current Status
    
    func checkAuthorizationStatus() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - Handle Device Token
    
    func handleDeviceToken(_ token: Data) {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        deviceToken = tokenString
        print("📱 Device token: \(tokenString)")
        
        // Save token to Supabase
        Task {
            await saveTokenToServer(tokenString)
        }
    }
    
    func handleRegistrationError(_ error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
    }
    
    // MARK: - Save Token to Server
    
    private func saveTokenToServer(_ token: String) async {
        guard let userId = SessionManager.shared.currentUserId else {
            print("⚠️ No user ID, cannot save push token")
            return
        }
        
        do {
            struct TokenUpdate: Encodable {
                let push_token: String
            }
            
            try await client
                .from("profiles")
                .update(TokenUpdate(push_token: token))
                .eq("id", value: userId.uuidString)
                .execute()
            
            print("✅ Push token saved to server")
        } catch {
            print("❌ Failed to save push token: \(error)")
        }
    }
    
    // MARK: - Local Notifications (Fallback)
    
    /// Show a local notification (for testing or when server push isn't available)
    func showLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to show local notification: \(error)")
            }
        }
    }
    
    /// Show match notification locally
    func showMatchNotification(name: String) {
        showLocalNotification(
            title: "🎉 It's a Match!",
            body: "Jullie vinden '\(name)' allebei een geweldige naam!"
        )
    }
    
    /// Show new member notification locally
    func showNewMemberNotification(memberName: String) {
        showLocalNotification(
            title: "👋 Nieuw lid!",
            body: "\(memberName) is toegetreden tot je household!"
        )
    }
    
    // MARK: - Send Push to Other Household Members
    
    /// Sends push notification to other household members via Edge Function
    func sendMatchPushToHousehold(householdId: UUID, name: String) async {
        guard let userId = SessionManager.shared.currentUserId else { return }
        
        do {
            struct PushRequest: Encodable {
                let type: String
                let household_id: String
                let exclude_user_id: String
                let payload: Payload
                
                struct Payload: Encodable {
                    let name: String
                }
            }
            
            let request = PushRequest(
                type: "match",
                household_id: householdId.uuidString,
                exclude_user_id: userId.uuidString,
                payload: .init(name: name)
            )
            
            try await client.functions.invoke(
                "send-push",
                options: .init(body: request)
            )
            
            print("✅ Push notification sent to household members")
        } catch {
            print("⚠️ Failed to send push to household: \(error)")
            // Non-critical - local notification already shown
        }
    }
    
    /// Sends push notification when new member joins
    func sendNewMemberPushToHousehold(householdId: UUID, memberName: String) async {
        guard let userId = SessionManager.shared.currentUserId else { return }
        
        do {
            struct PushRequest: Encodable {
                let type: String
                let household_id: String
                let exclude_user_id: String
                let payload: Payload
                
                struct Payload: Encodable {
                    let member_name: String
                }
            }
            
            let request = PushRequest(
                type: "new_member",
                household_id: householdId.uuidString,
                exclude_user_id: userId.uuidString,
                payload: .init(member_name: memberName)
            )
            
            try await client.functions.invoke(
                "send-push",
                options: .init(body: request)
            )
            
            print("✅ New member push sent to household")
        } catch {
            print("⚠️ Failed to send new member push: \(error)")
        }
    }
}

// MARK: - Import Supabase

import Supabase
