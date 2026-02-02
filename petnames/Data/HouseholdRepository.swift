//
//  HouseholdRepository.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation
import Supabase

/// Repository for household-related operations
@MainActor
final class HouseholdRepository {
    static let shared = HouseholdRepository()
    
    private var client: SupabaseClient {
        SupabaseClientProvider.shared.client
    }
    
    private init() {}
    
    // MARK: - Create Household
    
    /// Creates a new household and returns the household ID and invite code
    func createHousehold(displayName: String?) async throws -> (householdId: UUID, inviteCode: String) {
        struct Params: Encodable {
            let display_name: String?
        }
        
        let response: CreateHouseholdResponse = try await client
            .rpc("create_household", params: Params(display_name: displayName))
            .execute()
            .value
        
        return (response.householdId, response.inviteCode)
    }
    
    // MARK: - Join Household
    
    /// Joins an existing household using an invite code
    func joinHousehold(inviteCode: String) async throws -> UUID {
        struct Params: Encodable {
            let invite_code: String
        }
        
        let response: JoinHouseholdResponse = try await client
            .rpc("join_household", params: Params(invite_code: inviteCode))
            .execute()
            .value
        
        return response.householdId
    }
    
    // MARK: - Fetch Invite Code
    
    /// Fetches the invite code for a household
    func fetchInviteCode(householdId: UUID) async throws -> String {
        let household: Household = try await client
            .from("households")
            .select("id, invite_code")
            .eq("id", value: householdId.uuidString)
            .single()
            .execute()
            .value
        
        return household.inviteCode
    }
    
    // MARK: - Fetch Household Members
    
    /// Fetches all members (profiles) in a household
    func fetchHouseholdMembers(householdId: UUID) async throws -> [HouseholdMember] {
        let members: [HouseholdMember] = try await client
            .from("profiles")
            .select("id, display_name, created_at")
            .eq("household_id", value: householdId.uuidString)
            .order("created_at", ascending: true)
            .execute()
            .value
        
        return members
    }
    
    // MARK: - Update Display Name
    
    /// Updates the current user's display name
    func updateDisplayName(userId: UUID, displayName: String) async throws {
        struct UpdateData: Encodable {
            let display_name: String
        }
        
        try await client
            .from("profiles")
            .update(UpdateData(display_name: displayName))
            .eq("id", value: userId.uuidString)
            .execute()
    }
}

// MARK: - Errors

enum HouseholdError: LocalizedError {
    case inviteCodeNotFound
    case createFailed
    
    var errorDescription: String? {
        switch self {
        case .inviteCodeNotFound:
            return "Invite code not found. Please check and try again."
        case .createFailed:
            return "Failed to create household. Please try again."
        }
    }
}
