//
//  SupabaseClientProvider.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import Supabase
import Auth

/// Provides a singleton Supabase client instance
@MainActor
final class SupabaseClientProvider: Sendable {
    static let shared = SupabaseClientProvider()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: AppConfig.supabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey,
            options: SupabaseClientOptions(
                auth: SupabaseClientOptions.AuthOptions(
                    flowType: .implicit,
                    autoRefreshToken: true,
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
}
