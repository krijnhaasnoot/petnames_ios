//
//  AnalyticsManager.swift
//  petnames
//
//  Petnames by Kinder
//  Firebase Analytics tracking
//

import Foundation
import FirebaseAnalytics

/// Centralized analytics tracking manager
final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Onboarding & Households
    
    func trackHouseholdCreated() {
        Analytics.logEvent("household_created", parameters: nil)
        setUserProperty("creator", forName: "household_role")
    }
    
    func trackHouseholdJoined() {
        Analytics.logEvent("household_joined", parameters: nil)
        setUserProperty("joiner", forName: "household_role")
    }
    
    func trackOnboardingCompleted(method: String) {
        Analytics.logEvent("onboarding_completed", parameters: [
            "method": method // "create" or "join"
        ])
    }
    
    // MARK: - Swiping
    
    func trackNameSwiped(decision: String, name: String, gender: String, language: String, style: String) {
        // General swipe event for aggregated stats
        Analytics.logEvent("name_swiped", parameters: [
            "decision": decision, // "like" or "dismiss"
            "gender": gender,
            "language": language,
            "style": style
        ])
        
        // Track individual name popularity (for detailed analysis)
        if decision == "like" {
            trackNameLiked(name: name, gender: gender, language: language, style: style)
        } else {
            trackNameDismissed(name: name, gender: gender, language: language, style: style)
        }
    }
    
    func trackSwipeUndone() {
        Analytics.logEvent("swipe_undone", parameters: nil)
    }
    
    // MARK: - Name Popularity
    
    /// Track when a specific name is liked - for popularity analysis
    private func trackNameLiked(name: String, gender: String, language: String, style: String) {
        Analytics.logEvent("name_liked", parameters: [
            AnalyticsParameterItemID: name.lowercased(), // Normalized name as ID
            AnalyticsParameterItemName: name,            // Original name
            AnalyticsParameterItemCategory: style,       // Style category
            "gender": gender,
            "language": language
        ])
    }
    
    /// Track when a specific name is dismissed - for like/dismiss ratio
    private func trackNameDismissed(name: String, gender: String, language: String, style: String) {
        Analytics.logEvent("name_dismissed", parameters: [
            AnalyticsParameterItemID: name.lowercased(),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: style,
            "gender": gender,
            "language": language
        ])
    }
    
    /// Track top liked names (call periodically or on session end)
    func trackTopLikedNames(_ names: [String]) {
        guard !names.isEmpty else { return }
        
        // Track up to 10 top names
        let topNames = Array(names.prefix(10))
        Analytics.logEvent("top_liked_names", parameters: [
            "names": topNames.joined(separator: ","),
            "count": topNames.count
        ])
    }
    
    func trackCardStackEmpty(filtersActive: Bool) {
        Analytics.logEvent("card_stack_empty", parameters: [
            "filters_active": filtersActive
        ])
    }
    
    // MARK: - Filters
    
    func trackFilterChanged(filterType: String, value: String) {
        Analytics.logEvent("filter_changed", parameters: [
            "filter_type": filterType,
            "value": value
        ])
    }
    
    func trackLanguagesSelected(languages: [String]) {
        Analytics.logEvent("languages_selected", parameters: [
            "count": languages.count,
            "languages": languages.joined(separator: ",")
        ])
        setUserProperty(String(languages.count), forName: "languages_count")
    }
    
    func trackStylesEnabled(styles: [String]) {
        Analytics.logEvent("styles_enabled", parameters: [
            "count": styles.count,
            "styles": styles.joined(separator: ",")
        ])
    }
    
    // MARK: - Matches
    
    func trackMatchCreated(name: String, gender: String, householdSize: Int) {
        // Track match event
        Analytics.logEvent("match_created", parameters: [
            AnalyticsParameterItemID: name.lowercased(),
            AnalyticsParameterItemName: name,
            "gender": gender,
            "household_size": householdSize
        ])
        
        // Also track as a "popular" name (matched = liked by multiple people)
        Analytics.logEvent("name_matched", parameters: [
            AnalyticsParameterItemID: name.lowercased(),
            AnalyticsParameterItemName: name,
            "gender": gender
        ])
    }
    
    func trackMatchViewed(name: String) {
        Analytics.logEvent("match_viewed", parameters: [
            AnalyticsParameterItemID: name.lowercased(),
            AnalyticsParameterItemName: name
        ])
    }
    
    func trackMatchShared(shareType: String, name: String? = nil) {
        var params: [String: Any] = [
            "share_type": shareType // "single" or "list"
        ]
        if let name = name {
            params[AnalyticsParameterItemName] = name
        }
        Analytics.logEvent("match_shared", parameters: params)
    }
    
    // MARK: - Features
    
    func trackPetPhotoUploaded() {
        Analytics.logEvent("pet_photo_uploaded", parameters: nil)
        setUserProperty("true", forName: "has_pet_photo")
    }
    
    func trackPetPhotoRemoved() {
        Analytics.logEvent("pet_photo_removed", parameters: nil)
        setUserProperty("false", forName: "has_pet_photo")
    }
    
    func trackLikesViewed(count: Int) {
        Analytics.logEvent("likes_viewed", parameters: [
            "count": count
        ])
    }
    
    func trackProfileViewed() {
        Analytics.logEvent("profile_viewed", parameters: nil)
    }
    
    func trackAboutViewed() {
        Analytics.logEvent("about_viewed", parameters: nil)
    }
    
    func trackMatchesListViewed(count: Int) {
        Analytics.logEvent("matches_list_viewed", parameters: [
            "count": count
        ])
    }
    
    // MARK: - Notifications
    
    func trackNotificationPermissionShown() {
        Analytics.logEvent("notification_permission_shown", parameters: nil)
    }
    
    func trackNotificationPermissionGranted() {
        Analytics.logEvent("notification_permission_granted", parameters: nil)
        setUserProperty("true", forName: "notifications_enabled")
    }
    
    func trackNotificationPermissionDenied() {
        Analytics.logEvent("notification_permission_denied", parameters: nil)
        setUserProperty("false", forName: "notifications_enabled")
    }
    
    func trackNotificationTapped(type: String) {
        Analytics.logEvent("notification_tapped", parameters: [
            "type": type // "match" or "new_member"
        ])
    }
    
    // MARK: - Screen Views
    
    func trackScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    // MARK: - User Properties
    
    private func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    /// Set household size for segmentation
    func setHouseholdSize(_ size: Int) {
        setUserProperty(String(size), forName: "household_size")
    }
}
