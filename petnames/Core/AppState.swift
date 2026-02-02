//
//  AppState.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import SwiftUI

/// Main application state observable
@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    
    // MARK: - Published Properties
    
    @Published var householdId: UUID?
    @Published var inviteCode: String?
    @Published var filters: Filters
    @Published var enabledSetIds: [UUID]
    @Published var nameSets: [NameSet] = []
    
    // Language selection - multi-select for swiping
    @Published var selectedLanguages: Set<PetLanguage>  // Languages used for swiping
    @Published var viewingLanguage: PetLanguage         // Currently viewing in filters UI
    
    // Style preferences - shared across all languages (simplified)
    @Published var enabledStyles: Set<PetStyle>
    
    // MARK: - Computed Properties
    
    var isOnboarded: Bool {
        householdId != nil
    }
    
    /// Languages sorted for display (selected ones only)
    var sortedSelectedLanguages: [PetLanguage] {
        PetLanguage.allCases.filter { selectedLanguages.contains($0) }
    }
    
    /// Available languages based on what's in the database
    var availableLanguages: Set<PetLanguage> {
        NameSetClassifier.availableLanguages(from: nameSets)
    }
    
    /// Available styles across all selected languages
    var availableStyles: Set<PetStyle> {
        var styles = Set<PetStyle>()
        for language in selectedLanguages {
            styles.formUnion(NameSetClassifier.availableStyles(for: language, from: nameSets))
        }
        return styles
    }
    
    /// Check if all available styles are enabled
    var allStylesEnabled: Bool {
        let available = availableStyles
        guard !available.isEmpty else { return false }
        return available.isSubset(of: enabledStyles)
    }
    
    // MARK: - Init
    
    private init() {
        // Load from persistence
        self.householdId = Persistence.householdId
        self.filters = Persistence.filters
        self.enabledSetIds = Persistence.enabledSetIds ?? []
        
        // Load language preferences
        self.selectedLanguages = Persistence.selectedLanguages
        self.viewingLanguage = Persistence.viewingLanguage
        
        // Load styles (shared across languages)
        self.enabledStyles = Persistence.enabledStyles ?? Set(PetStyle.allCases)
    }
    
    // MARK: - Persistence
    
    func loadFromDefaults() {
        householdId = Persistence.householdId
        filters = Persistence.filters
        enabledSetIds = Persistence.enabledSetIds ?? []
        selectedLanguages = Persistence.selectedLanguages
        viewingLanguage = Persistence.viewingLanguage
        enabledStyles = Persistence.enabledStyles ?? Set(PetStyle.allCases)
    }
    
    func saveToDefaults() {
        Persistence.householdId = householdId
        Persistence.filters = filters
        Persistence.enabledSetIds = enabledSetIds
        Persistence.selectedLanguages = selectedLanguages
        Persistence.viewingLanguage = viewingLanguage
        Persistence.enabledStyles = enabledStyles
    }
    
    func saveFilters() {
        Persistence.filters = filters
    }
    
    func saveEnabledSets() {
        Persistence.enabledSetIds = enabledSetIds
    }
    
    func saveLanguageSettings() {
        Persistence.selectedLanguages = selectedLanguages
        Persistence.viewingLanguage = viewingLanguage
        Persistence.enabledStyles = enabledStyles
    }
    
    // MARK: - Household Actions
    
    func setHousehold(id: UUID, inviteCode: String? = nil) {
        self.householdId = id
        self.inviteCode = inviteCode
        Persistence.householdId = id
    }
    
    func resetHousehold() {
        householdId = nil
        inviteCode = nil
        Persistence.clearHousehold()
    }
    
    // MARK: - Name Sets
    
    func updateNameSets(_ sets: [NameSet]) {
        self.nameSets = sets
        // Recompute enabled set IDs based on language & styles
        recomputeEnabledSetIds()
    }
    
    /// Recompute enabledSetIds from selectedLanguages + enabledStyles
    func recomputeEnabledSetIds() {
        var ids: [UUID] = []
        
        // Get set IDs for all selected languages and enabled styles
        for language in selectedLanguages {
            let languageIds = NameSetClassifier.setIds(
                for: language,
                enabledStyles: enabledStyles,
                from: nameSets
            )
            ids.append(contentsOf: languageIds)
        }
        
        // Fallback: if no sets found, enable all sets for selected languages
        if ids.isEmpty {
            for language in selectedLanguages {
                let languageSets = NameSetClassifier.sets(for: language, from: nameSets)
                ids.append(contentsOf: languageSets.map { $0.id })
            }
        }
        
        // If still empty, enable everything
        if ids.isEmpty {
            ids = nameSets.map { $0.id }
        }
        
        enabledSetIds = ids
        saveEnabledSets()
    }
    
    // MARK: - Language Actions
    
    func toggleLanguage(_ language: PetLanguage) {
        if selectedLanguages.contains(language) {
            // Don't allow disabling the last language
            if selectedLanguages.count > 1 {
                selectedLanguages.remove(language)
                // If we removed the viewing language, switch to another
                if viewingLanguage == language {
                    viewingLanguage = sortedSelectedLanguages.first ?? .en
                }
            }
        } else {
            selectedLanguages.insert(language)
        }
        saveLanguageSettings()
        recomputeEnabledSetIds()
    }
    
    func setViewingLanguage(_ language: PetLanguage) {
        // Ensure the language is selected
        if !selectedLanguages.contains(language) {
            selectedLanguages.insert(language)
        }
        viewingLanguage = language
        saveLanguageSettings()
    }
    
    // MARK: - Style Actions
    
    func toggleStyle(_ style: PetStyle) {
        if enabledStyles.contains(style) {
            enabledStyles.remove(style)
        } else {
            enabledStyles.insert(style)
        }
        saveLanguageSettings()
        recomputeEnabledSetIds()
    }
    
    func selectAllStyles() {
        enabledStyles = availableStyles
        saveLanguageSettings()
        recomputeEnabledSetIds()
    }
    
    func deselectAllStyles() {
        enabledStyles = []
        saveLanguageSettings()
        recomputeEnabledSetIds()
    }
    
    // MARK: - Legacy methods (kept for compatibility)
    
    func toggleSet(_ setId: UUID) {
        if enabledSetIds.contains(setId) {
            enabledSetIds.removeAll { $0 == setId }
        } else {
            enabledSetIds.append(setId)
        }
        saveEnabledSets()
    }
    
    func toggleAllSets(enabled: Bool) {
        if enabled {
            enabledSetIds = nameSets.map { $0.id }
        } else {
            enabledSetIds = []
        }
        saveEnabledSets()
    }
    
    var allSetsEnabled: Bool {
        !nameSets.isEmpty && enabledSetIds.count == nameSets.count
    }
}
