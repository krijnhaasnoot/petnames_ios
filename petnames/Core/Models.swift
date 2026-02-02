//
//  Models.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import Foundation

// MARK: - Name Card

struct NameCard: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let name: String
    let gender: String
    let setTitle: String
    let setId: UUID
    let isLocal: Bool // True for bundled/offline names, false for server names
    
    enum CodingKeys: String, CodingKey {
        case id = "name_id"
        case name
        case gender
        case setTitle = "set_title"
        case setId = "set_id"
        case isLocal = "is_local"
    }
    
    init(id: UUID, name: String, gender: String, setTitle: String, setId: UUID, isLocal: Bool = false) {
        self.id = id
        self.name = name
        self.gender = gender
        self.setTitle = setTitle
        self.setId = setId
        self.isLocal = isLocal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        setTitle = try container.decode(String.self, forKey: .setTitle)
        setId = try container.decode(UUID.self, forKey: .setId)
        isLocal = try container.decodeIfPresent(Bool.self, forKey: .isLocal) ?? false
    }
}

// MARK: - Name Set

struct NameSet: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let slug: String
    let title: String
    let isFree: Bool
    let language: String?      // New: "nl", "en", "de", etc.
    let style: String?         // New: "cute", "strong", "classic", etc.
    let description: String?   // New: localized description
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case title
        case isFree = "is_free"
        case language
        case style
        case description
    }
}

// MARK: - Swipe Decision

enum SwipeDecision: String, Codable, Sendable {
    case like
    case dismiss
}

// MARK: - Swipe Record

struct SwipeRecord: Codable, Sendable {
    let householdId: UUID
    let userId: UUID
    let nameId: UUID
    let decision: String
    
    enum CodingKeys: String, CodingKey {
        case householdId = "household_id"
        case userId = "user_id"
        case nameId = "name_id"
        case decision
    }
}

// MARK: - Liked Name Row (for Likes list)

struct LikedNameRow: Identifiable, Codable, Sendable {
    var id: UUID { nameId }
    let nameId: UUID
    let name: String
    let gender: String
    let setTitle: String
    
    enum CodingKeys: String, CodingKey {
        case nameId = "name_id"
        case name
        case gender
        case setTitle = "set_title"
    }
}

// MARK: - Match Row (for Matches list)

struct MatchRow: Identifiable, Codable, Sendable {
    var id: UUID { nameId }
    let nameId: UUID
    let name: String
    let gender: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case nameId = "name_id"
        case name
        case gender
        case likesCount = "likes_count"
    }
}

// MARK: - Household Response

struct CreateHouseholdResponse: Codable, Sendable {
    let householdId: UUID
    let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case householdId = "household_id"
        case inviteCode = "invite_code"
    }
}

struct JoinHouseholdResponse: Codable, Sendable {
    let householdId: UUID
    
    enum CodingKeys: String, CodingKey {
        case householdId = "household_id"
    }
}

// MARK: - Household

struct Household: Codable, Sendable {
    let id: UUID
    let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case inviteCode = "invite_code"
    }
}

// MARK: - Profile

struct Profile: Codable, Sendable {
    let id: UUID
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
    }
}

// MARK: - Household Member

struct HouseholdMember: Identifiable, Codable, Sendable {
    let id: UUID
    let displayName: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case createdAt = "created_at"
    }
    
    /// Display name with fallback for anonymous users
    var displayLabel: String {
        if let name = displayName, !name.isEmpty {
            return name
        }
        // Use first 8 chars of UUID as anonymous identifier
        return "User \(id.uuidString.prefix(8))"
    }
}

// MARK: - Filters

struct Filters: Codable, Equatable, Sendable {
    var gender: String = "any"       // "any", "male", "female", "neutral"
    var startsWith: String = "any"   // "any", "a"..."z"
    var maxLength: Int = 0           // 0 = all
    
    static let `default` = Filters()
    
    static let genderOptions = ["any", "male", "female", "neutral"]
    static let startsWithOptions = ["any"] + (UnicodeScalar("a").value...UnicodeScalar("z").value).map { String(UnicodeScalar($0)!) }
}

// MARK: - Swipe Counts

struct SwipeCounts: Sendable {
    let likes: Int
    let dismisses: Int
}
