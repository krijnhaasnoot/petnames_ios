//
//  LocalNamesProvider.swift
//  petnames
//
//  Petnames by Kinder - POC
//  Offline-first name provider with sync capability
//

import Foundation

// MARK: - Local Name Models

struct BundledNameSet: Codable {
    let slug: String
    let title: String
    let description: String
    let language: String
    let style: String
    let names: [BundledName]
}

struct BundledName: Codable {
    let name: String
    let gender: String
}

struct BundledNamesData: Codable {
    let version: Int
    let lastUpdated: String
    let nameSets: [BundledNameSet]
}

// MARK: - Local Names Provider

/// Provides offline access to bundled names with sync capability
@MainActor
final class LocalNamesProvider {
    static let shared = LocalNamesProvider()
    
    private var bundledData: BundledNamesData?
    private var cachedData: BundledNamesData?
    private var allNames: [LocalNameEntry] = []
    private var nameSetMap: [String: BundledNameSet] = [:] // slug -> set
    
    // UserDefaults keys
    private let cachedDataKey = "petnames_cached_names_data"
    private let lastSyncKey = "petnames_last_sync_timestamp"
    private let dataVersionKey = "petnames_data_version"
    
    private init() {
        loadBundledData()
        loadCachedData()
        buildNameIndex()
    }
    
    // MARK: - Data Loading
    
    /// Load bundled JSON from app bundle
    private func loadBundledData() {
        guard let url = Bundle.main.url(forResource: "bundled_names", withExtension: "json") else {
            print("⚠️ bundled_names.json not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            bundledData = try decoder.decode(BundledNamesData.self, from: data)
            print("✅ Loaded bundled names: \(bundledData?.nameSets.count ?? 0) sets")
        } catch {
            print("❌ Failed to load bundled names: \(error)")
        }
    }
    
    /// Load cached data from UserDefaults (updated from server)
    private func loadCachedData() {
        guard let data = UserDefaults.standard.data(forKey: cachedDataKey) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            cachedData = try decoder.decode(BundledNamesData.self, from: data)
            print("✅ Loaded cached names: \(cachedData?.nameSets.count ?? 0) sets")
        } catch {
            print("❌ Failed to load cached names: \(error)")
            UserDefaults.standard.removeObject(forKey: cachedDataKey)
        }
    }
    
    /// Build index of all names for quick lookup
    /// Deduplicates by name - each name appears only once
    private func buildNameIndex() {
        allNames.removeAll()
        nameSetMap.removeAll()
        
        // Prefer cached data over bundled
        let sourceData = cachedData ?? bundledData
        
        guard let data = sourceData else {
            print("⚠️ No name data available")
            return
        }
        
        // Track names we've already added (case-insensitive)
        var seenNames = Set<String>()
        
        for nameSet in data.nameSets {
            nameSetMap[nameSet.slug] = nameSet
            
            for bundledName in nameSet.names {
                let nameLower = bundledName.name.lowercased()
                
                // Skip if we've already added this name
                guard !seenNames.contains(nameLower) else { continue }
                seenNames.insert(nameLower)
                
                let entry = LocalNameEntry(
                    name: bundledName.name,
                    gender: bundledName.gender,
                    setSlug: nameSet.slug,
                    setTitle: nameSet.title,
                    language: nameSet.language,
                    style: nameSet.style
                )
                allNames.append(entry)
            }
        }
        
        // Shuffle for variety
        allNames.shuffle()
        
        print("📊 Indexed \(allNames.count) unique names from \(nameSetMap.count) sets")
    }
    
    // MARK: - Public API
    
    /// Get name sets matching language/style filters
    func getNameSets(languages: Set<PetLanguage>, styles: Set<PetStyle>) -> [BundledNameSet] {
        let sourceData = cachedData ?? bundledData
        guard let data = sourceData else { return [] }
        
        return data.nameSets.filter { set in
            guard let lang = PetLanguage(rawValue: set.language),
                  let style = PetStyle(rawValue: set.style) else {
                return false
            }
            return languages.contains(lang) && styles.contains(style)
        }
    }
    
    /// Get all available name set slugs
    func getAllNameSetSlugs() -> [String] {
        let sourceData = cachedData ?? bundledData
        return sourceData?.nameSets.map { $0.slug } ?? []
    }
    
    /// Get names for swiping with filters
    /// Returns unique names only - no duplicates
    func getNames(
        enabledSetSlugs: Set<String>,
        gender: String,
        startsWith: String,
        maxLength: Int,
        excludeNames: Set<String>,
        limit: Int
    ) -> [LocalNameEntry] {
        var results: [LocalNameEntry] = []
        var resultNames = Set<String>() // Track names already in results
        
        for entry in allNames {
            let nameLower = entry.name.lowercased()
            
            // Check if already in results (extra safety)
            guard !resultNames.contains(nameLower) else { continue }
            
            // Check if set is enabled
            guard enabledSetSlugs.contains(entry.setSlug) else { continue }
            
            // Check if already excluded (swiped)
            guard !excludeNames.contains(nameLower) else { continue }
            
            // Gender filter
            if gender != "any" && entry.gender != gender && entry.gender != "neutral" {
                continue
            }
            
            // Starts with filter
            if startsWith != "any" {
                let firstChar = nameLower.prefix(1)
                if firstChar != startsWith.lowercased() {
                    continue
                }
            }
            
            // Max length filter
            if maxLength > 0 && entry.name.count > maxLength {
                continue
            }
            
            results.append(entry)
            resultNames.insert(nameLower)
            
            if results.count >= limit {
                break
            }
        }
        
        return results
    }
    
    /// Convert local name entry to NameCard for UI
    func toNameCard(_ entry: LocalNameEntry) -> NameCard {
        NameCard(
            id: UUID(), // Generate new UUID for local names
            name: entry.name,
            gender: entry.gender,
            setTitle: entry.setTitle,
            setId: UUID(), // Placeholder set ID
            isLocal: true // Mark as local - won't sync to Supabase
        )
    }
    
    /// Get total count of available names
    var totalNameCount: Int {
        allNames.count
    }
    
    /// Get data version
    var currentVersion: Int {
        (cachedData ?? bundledData)?.version ?? 0
    }
    
    // MARK: - Sync with Server
    
    /// Check if sync is needed (once per day)
    var shouldSync: Bool {
        let lastSync = UserDefaults.standard.double(forKey: lastSyncKey)
        let now = Date().timeIntervalSince1970
        let oneDayInSeconds: Double = 86400
        return (now - lastSync) > oneDayInSeconds
    }
    
    /// Update cached data from server response
    func updateFromServer(nameSets: [NameSet], names: [ServerName]) {
        // Convert server data to bundled format
        var namesBySet: [UUID: [BundledName]] = [:]
        
        // Group names by set
        for name in names {
            if namesBySet[name.setId] == nil {
                namesBySet[name.setId] = []
            }
            namesBySet[name.setId]?.append(BundledName(name: name.name, gender: name.gender))
        }
        
        // Build bundled sets
        var bundledSets: [BundledNameSet] = []
        for set in nameSets {
            let setNames = namesBySet[set.id] ?? []
            let bundledSet = BundledNameSet(
                slug: set.slug,
                title: set.title,
                description: set.description ?? "",
                language: set.language ?? "en",
                style: set.style ?? "classic",
                names: setNames
            )
            bundledSets.append(bundledSet)
        }
        
        // Create new cached data with incremented version
        let newData = BundledNamesData(
            version: currentVersion + 1,
            lastUpdated: ISO8601DateFormatter().string(from: Date()),
            nameSets: bundledSets
        )
        
        // Save to UserDefaults
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(newData)
            UserDefaults.standard.set(data, forKey: cachedDataKey)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastSyncKey)
            
            cachedData = newData
            buildNameIndex()
            
            print("✅ Synced \(bundledSets.count) sets with \(names.count) names from server")
        } catch {
            print("❌ Failed to cache server data: \(error)")
        }
    }
    
    /// Clear cached data (keep bundled)
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cachedDataKey)
        UserDefaults.standard.removeObject(forKey: lastSyncKey)
        cachedData = nil
        buildNameIndex()
    }
}

// MARK: - Local Name Entry

struct LocalNameEntry {
    let name: String
    let gender: String
    let setSlug: String
    let setTitle: String
    let language: String
    let style: String
}

// MARK: - Server Name Model (for sync)

struct ServerName: Codable {
    let id: UUID
    let name: String
    let gender: String
    let setId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case setId = "set_id"
    }
}
