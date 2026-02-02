//
//  Persistence.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation

/// UserDefaults keys and persistence helpers
enum Persistence {
    private static let defaults = UserDefaults.standard
    
    // MARK: - Keys
    
    private enum Keys {
        static let householdId = "petnames_household_id"
        static let filters = "petnames_filters"
        static let enabledSetIds = "petnames_enabled_set_ids"
        // Language preferences (updated)
        static let selectedLanguages = "petnames_selected_languages"
        static let viewingLanguage = "petnames_viewing_language"
        static let enabledStyles = "petnames_enabled_styles"
    }
    
    // MARK: - Household ID
    
    static var householdId: UUID? {
        get {
            guard let string = defaults.string(forKey: Keys.householdId) else { return nil }
            return UUID(uuidString: string)
        }
        set {
            defaults.set(newValue?.uuidString, forKey: Keys.householdId)
        }
    }
    
    // MARK: - Filters
    
    static var filters: Filters {
        get {
            guard let data = defaults.data(forKey: Keys.filters),
                  let filters = try? JSONDecoder().decode(Filters.self, from: data) else {
                return .default
            }
            return filters
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: Keys.filters)
            }
        }
    }
    
    // MARK: - Enabled Set IDs (computed cache)
    
    static var enabledSetIds: [UUID]? {
        get {
            guard let data = defaults.data(forKey: Keys.enabledSetIds),
                  let ids = try? JSONDecoder().decode([UUID].self, from: data) else {
                return nil
            }
            return ids
        }
        set {
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: Keys.enabledSetIds)
            } else {
                defaults.removeObject(forKey: Keys.enabledSetIds)
            }
        }
    }
    
    // MARK: - Selected Languages (for swiping - multi-select)
    
    static var selectedLanguages: Set<PetLanguage> {
        get {
            guard let data = defaults.data(forKey: Keys.selectedLanguages),
                  let rawValues = try? JSONDecoder().decode([String].self, from: data) else {
                // Default: Dutch and English selected
                return [.nl, .en]
            }
            let languages = rawValues.compactMap { PetLanguage(rawValue: $0) }
            return languages.isEmpty ? [.en] : Set(languages)
        }
        set {
            let rawValues = newValue.map { $0.rawValue }
            if let data = try? JSONEncoder().encode(rawValues) {
                defaults.set(data, forKey: Keys.selectedLanguages)
            }
        }
    }
    
    // MARK: - Viewing Language (for filter UI)
    
    static var viewingLanguage: PetLanguage {
        get {
            guard let rawValue = defaults.string(forKey: Keys.viewingLanguage),
                  let language = PetLanguage(rawValue: rawValue) else {
                return .en // Default to English
            }
            return language
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.viewingLanguage)
        }
    }
    
    // MARK: - Enabled Styles (shared across all languages)
    
    static var enabledStyles: Set<PetStyle>? {
        get {
            guard let data = defaults.data(forKey: Keys.enabledStyles),
                  let rawValues = try? JSONDecoder().decode([String].self, from: data) else {
                return nil // Will default to all styles in AppState
            }
            let styles = rawValues.compactMap { PetStyle(rawValue: $0) }
            return styles.isEmpty ? nil : Set(styles)
        }
        set {
            if let styles = newValue {
                let rawValues = styles.map { $0.rawValue }
                if let data = try? JSONEncoder().encode(rawValues) {
                    defaults.set(data, forKey: Keys.enabledStyles)
                }
            } else {
                defaults.removeObject(forKey: Keys.enabledStyles)
            }
        }
    }
    
    // MARK: - Clear All
    
    static func clearAll() {
        defaults.removeObject(forKey: Keys.householdId)
        defaults.removeObject(forKey: Keys.filters)
        defaults.removeObject(forKey: Keys.enabledSetIds)
        defaults.removeObject(forKey: Keys.selectedLanguages)
        defaults.removeObject(forKey: Keys.viewingLanguage)
        defaults.removeObject(forKey: Keys.enabledStyles)
    }
    
    static func clearHousehold() {
        defaults.removeObject(forKey: Keys.householdId)
    }
}
