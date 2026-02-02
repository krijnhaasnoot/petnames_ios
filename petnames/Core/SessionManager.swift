//
//  SessionManager.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import Supabase

/// Manages anonymous authentication session
@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUserId: UUID?
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    private init() {}
    
    /// Sign in anonymously if there's no existing session
    func signInAnonymouslyIfNeeded() async throws {
        // Check if we already have a session
        if let session = try? await client.auth.session {
            self.currentUserId = session.user.id
            self.isAuthenticated = true
            return
        }
        
        // Sign in anonymously
        let session = try await client.auth.signInAnonymously()
        self.currentUserId = session.user.id
        self.isAuthenticated = true
    }
    
    /// Get the current user ID, throwing if not authenticated
    func requireUserId() throws -> UUID {
        guard let userId = currentUserId else {
            throw SessionError.notAuthenticated
        }
        return userId
    }
}

// MARK: - Errors

enum SessionError: LocalizedError {
    case notAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated"
        }
    }
}
