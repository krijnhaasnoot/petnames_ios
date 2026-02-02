//
//  NamesRepository.swift
//  petnames
//
//  Petnames by Kinder - POC
//  Offline-first name repository with server sync
//

import Foundation
import Supabase

/// Repository for names and name sets operations
/// Uses offline-first approach: local bundled data + server sync
@MainActor
final class NamesRepository {
    static let shared = NamesRepository()
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    private let localProvider = LocalNamesProvider.shared
    
    // Track swiped names locally
    private var swipedNames: Set<String> = []
    
    private init() {
        loadSwipedNames()
        print("📋 Loaded \(swipedNames.count) swiped names from storage")
    }
    
    // MARK: - Swiped Names Tracking
    
    private let swipedNamesKey = "petnames_swiped_names"
    
    private func loadSwipedNames() {
        if let data = UserDefaults.standard.data(forKey: swipedNamesKey),
           let names = try? JSONDecoder().decode(Set<String>.self, from: data) {
            swipedNames = names
        }
    }
    
    private func saveSwipedNames() {
        if let data = try? JSONEncoder().encode(swipedNames) {
            UserDefaults.standard.set(data, forKey: swipedNamesKey)
        }
    }
    
    func markNameAsSwiped(_ name: String) {
        let nameLower = name.lowercased()
        let wasNew = swipedNames.insert(nameLower).inserted
        if wasNew {
            saveSwipedNames()
            print("✅ Marked '\(name)' as swiped (total: \(swipedNames.count))")
        }
    }
    
    func clearSwipedNames() {
        swipedNames.removeAll()
        saveSwipedNames()
    }
    
    func undoSwipe(_ name: String) {
        swipedNames.remove(name.lowercased())
        saveSwipedNames()
    }
    
    // MARK: - Fetch Name Sets (Offline-First)
    
    /// Fetches all available name sets
    /// Returns local data immediately, syncs from server in background
    func fetchNameSets() async throws -> [NameSet] {
        // Get local slugs as NameSet objects
        let localSlugs = localProvider.getAllNameSetSlugs()
        
        // Try to fetch from server (for sync)
        do {
            let serverSets: [NameSet] = try await client
                .from("name_sets")
                .select("id, slug, title, is_free, language, style, description")
                .order("language, style")
                .execute()
                .value
            
            // Trigger background sync if we have server data
            if localProvider.shouldSync {
                Task {
                    await syncNamesFromServer()
                }
            }
            
            return serverSets
        } catch {
            print("⚠️ Server fetch failed, using local data: \(error)")
            
            // Return local sets as NameSet objects
            return localSlugs.map { slug in
                NameSet(
                    id: UUID(),
                    slug: slug,
                    title: slug,
                    isFree: true,
                    language: nil,
                    style: nil,
                    description: nil
                )
            }
        }
    }
    
    // MARK: - Get Next Names (Offline-First)
    
    /// Gets multiple names to swipe based on filters
    /// Uses local data for instant response
    func getNextNames(
        householdId: UUID,
        enabledSetIds: [UUID],
        gender: String,
        startsWith: String,
        maxLength: Int,
        limit: Int = 10,
        excludeIds: [UUID] = [],
        excludeNames: [String] = []
    ) async throws -> [NameCard] {
        // Get enabled set slugs from AppState
        let appState = AppState.shared
        let enabledSlugs = getEnabledSetSlugs(
            languages: appState.selectedLanguages,
            styles: appState.enabledStyles
        )
        
        // Combine swiped names with additionally excluded names (e.g., names already in card stack)
        var allExcludedNames = swipedNames
        for name in excludeNames {
            allExcludedNames.insert(name.lowercased())
        }
        
        // Get names from local provider
        let localNames = localProvider.getNames(
            enabledSetSlugs: enabledSlugs,
            gender: gender,
            startsWith: startsWith,
            maxLength: maxLength,
            excludeNames: allExcludedNames,
            limit: limit
        )
        
        // Convert to NameCards
        let cards = localNames.map { localProvider.toNameCard($0) }
        
        if !cards.isEmpty {
            return cards
        }
        
        // Fallback: try server if local is empty
        return try await getNextNamesFromServer(
            householdId: householdId,
            enabledSetIds: enabledSetIds,
            gender: gender,
            startsWith: startsWith,
            maxLength: maxLength,
            limit: limit,
            excludeIds: excludeIds
        )
    }
    
    /// Get enabled set slugs based on language/style filters
    private func getEnabledSetSlugs(languages: Set<PetLanguage>, styles: Set<PetStyle>) -> Set<String> {
        var slugs = Set<String>()
        for lang in languages {
            for style in styles {
                slugs.insert("pets_\(lang.rawValue)_\(style.rawValue)")
            }
        }
        return slugs
    }
    
    // MARK: - Server Fallback
    
    /// Gets names from server (fallback when local is empty)
    private func getNextNamesFromServer(
        householdId: UUID,
        enabledSetIds: [UUID],
        gender: String,
        startsWith: String,
        maxLength: Int,
        limit: Int,
        excludeIds: [UUID]
    ) async throws -> [NameCard] {
        struct Params: Encodable {
            let p_household_id: String
            let p_enabled_set_ids: [String]
            let p_gender: String
            let p_starts_with: String
            let p_max_length: Int
            let p_limit: Int
            let p_exclude_ids: [String]
        }
        
        let params = Params(
            p_household_id: householdId.uuidString,
            p_enabled_set_ids: enabledSetIds.map { $0.uuidString },
            p_gender: gender,
            p_starts_with: startsWith,
            p_max_length: maxLength,
            p_limit: limit,
            p_exclude_ids: excludeIds.map { $0.uuidString }
        )
        
        let response = try await client
            .rpc("get_next_names", params: params)
            .execute()
        
        if let cards = try? JSONDecoder().decode([NameCard].self, from: response.data) {
            return cards
        }
        
        return []
    }
    
    // MARK: - Get Next Name (Single)
    
    /// Gets the next name to swipe based on filters
    func getNextName(
        householdId: UUID,
        enabledSetIds: [UUID],
        gender: String,
        startsWith: String,
        maxLength: Int
    ) async throws -> NameCard? {
        let cards = try await getNextNames(
            householdId: householdId,
            enabledSetIds: enabledSetIds,
            gender: gender,
            startsWith: startsWith,
            maxLength: maxLength,
            limit: 1
        )
        return cards.first
    }
    
    // MARK: - Server Sync
    
    /// Sync names from server to local cache
    func syncNamesFromServer() async {
        do {
            print("🔄 Starting server sync...")
            
            // Fetch all name sets
            let sets: [NameSet] = try await client
                .from("name_sets")
                .select("id, slug, title, is_free, language, style, description")
                .execute()
                .value
            
            // Fetch all names
            let names: [ServerName] = try await client
                .from("names")
                .select("id, name, gender, set_id")
                .execute()
                .value
            
            // Update local cache
            localProvider.updateFromServer(nameSets: sets, names: names)
            
            print("✅ Server sync complete: \(sets.count) sets, \(names.count) names")
        } catch {
            print("❌ Server sync failed: \(error)")
        }
    }
    
    // MARK: - Statistics
    
    /// Get total available names count
    var totalNamesCount: Int {
        localProvider.totalNameCount
    }
    
    /// Get swiped names count
    var swipedCount: Int {
        swipedNames.count
    }
    
    /// Get remaining names count
    var remainingCount: Int {
        totalNamesCount - swipedCount
    }
}
