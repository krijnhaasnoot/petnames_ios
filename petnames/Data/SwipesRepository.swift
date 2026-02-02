//
//  SwipesRepository.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import Supabase

/// Repository for swipe operations
@MainActor
final class SwipesRepository {
    static let shared = SwipesRepository()
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    // Local likes storage
    private let localLikesKey = "petnames_local_likes"
    private var localLikes: [LikedNameRow] = []
    
    private init() {
        loadLocalLikes()
    }
    
    // MARK: - Local Likes Storage
    
    private func loadLocalLikes() {
        if let data = UserDefaults.standard.data(forKey: localLikesKey),
           let likes = try? JSONDecoder().decode([LikedNameRow].self, from: data) {
            localLikes = likes
        }
    }
    
    private func saveLocalLikes() {
        if let data = try? JSONEncoder().encode(localLikes) {
            UserDefaults.standard.set(data, forKey: localLikesKey)
        }
    }
    
    /// Add a local like (for offline names)
    func addLocalLike(name: String, gender: String, setTitle: String) {
        let like = LikedNameRow(
            nameId: UUID(), // Generated ID for local likes
            name: name,
            gender: gender,
            setTitle: setTitle
        )
        // Avoid duplicates by name
        if !localLikes.contains(where: { $0.name.lowercased() == name.lowercased() }) {
            localLikes.insert(like, at: 0)
            saveLocalLikes()
        }
    }
    
    /// Remove a local like by name
    func removeLocalLike(name: String) {
        localLikes.removeAll { $0.name.lowercased() == name.lowercased() }
        saveLocalLikes()
    }
    
    /// Get local likes count
    var localLikesCount: Int {
        localLikes.count
    }
    
    /// Clear all local likes
    func clearLocalLikes() {
        localLikes.removeAll()
        saveLocalLikes()
    }
    
    // MARK: - Insert Swipe
    
    /// Records a swipe decision
    func insertSwipe(
        householdId: UUID,
        userId: UUID,
        nameId: UUID,
        decision: SwipeDecision
    ) async throws {
        let record = SwipeRecord(
            householdId: householdId,
            userId: userId,
            nameId: nameId,
            decision: decision.rawValue
        )
        
        try await client
            .from("swipes")
            .insert(record)
            .execute()
    }
    
    /// Records a swipe by looking up the name in the database
    /// Returns true if this created a new match
    func insertSwipeByName(
        householdId: UUID,
        userId: UUID,
        name: String,
        gender: String,
        decision: SwipeDecision
    ) async throws -> Bool {
        // First, look up the name in the database
        struct NameRecord: Codable {
            let id: UUID
        }
        
        let names: [NameRecord] = try await client
            .from("names")
            .select("id")
            .ilike("name", pattern: name)
            .limit(1)
            .execute()
            .value
        
        guard let nameRecord = names.first else {
            print("⚠️ Name '\(name)' not found in database")
            return false
        }
        
        // Insert the swipe with the real name ID
        let record = SwipeRecord(
            householdId: householdId,
            userId: userId,
            nameId: nameRecord.id,
            decision: decision.rawValue
        )
        
        try await client
            .from("swipes")
            .insert(record)
            .execute()
        
        // Check if this created a match (2+ likes for this name in the household)
        if decision == .like {
            return try await checkForMatch(householdId: householdId, nameId: nameRecord.id, userId: userId)
        }
        
        return false
    }
    
    /// Check if there's a match for this name in the household
    private func checkForMatch(householdId: UUID, nameId: UUID, userId: UUID) async throws -> Bool {
        // Count likes for this name in the household (excluding current user)
        let response = try await client
            .from("swipes")
            .select("user_id", head: true, count: .exact)
            .eq("household_id", value: householdId.uuidString)
            .eq("name_id", value: nameId.uuidString)
            .eq("decision", value: "like")
            .neq("user_id", value: userId.uuidString)
            .execute()
        
        // If at least one other person liked it, it's a match!
        return (response.count ?? 0) >= 1
    }
    
    /// Check if there's a match for this name by looking it up first
    func checkForMatchByName(householdId: UUID, name: String, userId: UUID) async throws -> Bool {
        // Look up the name
        struct NameRecord: Codable {
            let id: UUID
        }
        
        let names: [NameRecord] = try await client
            .from("names")
            .select("id")
            .ilike("name", pattern: name)
            .limit(1)
            .execute()
            .value
        
        guard let nameRecord = names.first else {
            return false
        }
        
        return try await checkForMatch(householdId: householdId, nameId: nameRecord.id, userId: userId)
    }
    
    // MARK: - Delete Swipe
    
    /// Deletes a swipe (for undo functionality)
    func deleteSwipe(
        householdId: UUID,
        userId: UUID,
        nameId: UUID
    ) async throws {
        try await client
            .from("swipes")
            .delete()
            .eq("household_id", value: householdId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .eq("name_id", value: nameId.uuidString)
            .execute()
    }
    
    // MARK: - Fetch Likes
    
    /// Fetches all liked names for the current user in a household
    /// Combines server likes with local likes
    func fetchLikes(householdId: UUID, userId: UUID) async throws -> [LikedNameRow] {
        // Start with local likes
        var allLikes = localLikes
        
        // Try to fetch from server
        do {
            let query = """
                name_id,
                names!inner(name, gender, set_id, name_sets!inner(title))
            """
            
            struct SwipeWithName: Codable {
                let nameId: UUID
                let names: NameData
                
                enum CodingKeys: String, CodingKey {
                    case nameId = "name_id"
                    case names
                }
                
                struct NameData: Codable {
                    let name: String
                    let gender: String
                    let nameSets: SetData
                    
                    enum CodingKeys: String, CodingKey {
                        case name
                        case gender
                        case nameSets = "name_sets"
                    }
                }
                
                struct SetData: Codable {
                    let title: String
                }
            }
            
            let swipes: [SwipeWithName] = try await client
                .from("swipes")
                .select(query)
                .eq("household_id", value: householdId.uuidString)
                .eq("user_id", value: userId.uuidString)
                .eq("decision", value: "like")
                .execute()
                .value
            
            let serverLikes = swipes.map { swipe in
                LikedNameRow(
                    nameId: swipe.nameId,
                    name: swipe.names.name,
                    gender: swipe.names.gender,
                    setTitle: swipe.names.nameSets.title
                )
            }
            
            // Add server likes that aren't already in local (avoid duplicates by name)
            for serverLike in serverLikes {
                if !allLikes.contains(where: { $0.name.lowercased() == serverLike.name.lowercased() }) {
                    allLikes.append(serverLike)
                }
            }
        } catch {
            print("⚠️ Failed to fetch server likes: \(error.localizedDescription)")
            // Continue with local likes only
        }
        
        return allLikes
    }
    
    // MARK: - Fetch Counts
    
    /// Fetches swipe counts for a user in a household
    /// Includes both local and server counts
    func fetchCounts(householdId: UUID, userId: UUID) async throws -> SwipeCounts {
        var serverLikes = 0
        var serverDismisses = 0
        
        // Try to fetch from server
        do {
            let likesResponse = try await client
                .from("swipes")
                .select("*", head: true, count: .exact)
                .eq("household_id", value: householdId.uuidString)
                .eq("user_id", value: userId.uuidString)
                .eq("decision", value: "like")
                .execute()
            
            let dismissResponse = try await client
                .from("swipes")
                .select("*", head: true, count: .exact)
                .eq("household_id", value: householdId.uuidString)
                .eq("user_id", value: userId.uuidString)
                .eq("decision", value: "dismiss")
                .execute()
            
            serverLikes = likesResponse.count ?? 0
            serverDismisses = dismissResponse.count ?? 0
        } catch {
            print("⚠️ Failed to fetch server counts: \(error.localizedDescription)")
        }
        
        // Combine server and local counts
        let totalLikes = serverLikes + localLikes.count
        let totalDismisses = serverDismisses + max(0, NamesRepository.shared.swipedCount - totalLikes)
        
        return SwipeCounts(
            likes: totalLikes,
            dismisses: totalDismisses
        )
    }
}
