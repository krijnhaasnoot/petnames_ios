//
//  MatchesRepository.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import Supabase

/// Repository for matches operations
@MainActor
final class MatchesRepository {
    static let shared = MatchesRepository()
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    private init() {}
    
    // MARK: - Fetch Matches
    
    /// Fetches all matches for a household (names liked by 2+ members)
    func fetchMatches(householdId: UUID) async throws -> [MatchRow] {
        // Query the household_matches view joined with names
        struct MatchViewRow: Codable {
            let nameId: UUID
            let likesCount: Int
            let names: NameData
            
            enum CodingKeys: String, CodingKey {
                case nameId = "name_id"
                case likesCount = "likes_count"
                case names
            }
            
            struct NameData: Codable {
                let name: String
                let gender: String
            }
        }
        
        let matches: [MatchViewRow] = try await client
            .from("household_matches")
            .select("name_id, likes_count, names!inner(name, gender)")
            .eq("household_id", value: householdId.uuidString)
            .order("likes_count", ascending: false)
            .execute()
            .value
        
        return matches.map { match in
            MatchRow(
                nameId: match.nameId,
                name: match.names.name,
                gender: match.names.gender,
                likesCount: match.likesCount
            )
        }
    }
    
    // MARK: - Fetch Likers
    
    /// Fetches the display names of users who liked a specific name in a household
    func fetchLikers(householdId: UUID, nameId: UUID) async throws -> [String] {
        // First get the user_ids who liked this name
        struct SwipeRecord: Codable {
            let userId: UUID
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
            }
        }
        
        let swipes: [SwipeRecord] = try await client
            .from("swipes")
            .select("user_id")
            .eq("household_id", value: householdId.uuidString)
            .eq("name_id", value: nameId.uuidString)
            .eq("decision", value: "like")
            .execute()
            .value
        
        guard !swipes.isEmpty else { return [] }
        
        // Then fetch profiles for those users
        struct ProfileRecord: Codable {
            let id: UUID
            let displayName: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case displayName = "display_name"
            }
        }
        
        let userIds = swipes.map { $0.userId.uuidString }
        
        let profiles: [ProfileRecord] = try await client
            .from("profiles")
            .select("id, display_name")
            .in("id", values: userIds)
            .execute()
            .value
        
        return profiles.map { profile in
            profile.displayName ?? "Anonymous"
        }
    }
}
