//
//  AppConfig.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation

/// Configuration for Supabase connection
/// TODO: Replace these placeholder values with your actual Supabase credentials
enum AppConfig {
    // MARK: - Supabase Configuration
    
    /// Your Supabase project URL
    static let supabaseURL: URL = URL(string: "https://tchxmxchnslufweglwkk.supabase.co")!
    
    /// Your Supabase anonymous key
    static let supabaseAnonKey: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaHhteGNobnNsdWZ3ZWdsd2trIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2NTc5OTksImV4cCI6MjA4NDIzMzk5OX0.ByGoHEiT5UoZRwqOG25R9_eUDxos72mAgor4QINvmrA"
    
    // MARK: - App Constants
    
    static let swipeThreshold: CGFloat = 100.0
    static let cardRotationMultiplier: Double = 0.025
    static let animationDuration: Double = 0.2
}
