//
//  petnamesTests.swift
//  petnamesTests
//
//  Unit tests for Petnames app
//

import XCTest
@testable import petnames

// MARK: - NameSetClassifier Tests

final class NameSetClassifierTests: XCTestCase {
    
    // MARK: - PetLanguage Tests
    
    func testPetLanguageAllCases() {
        // Should have exactly 10 languages
        XCTAssertEqual(PetLanguage.allCases.count, 10)
    }
    
    func testPetLanguageDisplayNames() {
        XCTAssertEqual(PetLanguage.nl.displayName, "Nederlands")
        XCTAssertEqual(PetLanguage.en.displayName, "English")
        XCTAssertEqual(PetLanguage.de.displayName, "Deutsch")
        XCTAssertEqual(PetLanguage.fr.displayName, "Français")
        XCTAssertEqual(PetLanguage.fi.displayName, "Suomi")
    }
    
    func testPetLanguageFlags() {
        XCTAssertEqual(PetLanguage.nl.flag, "🇳🇱")
        XCTAssertEqual(PetLanguage.en.flag, "🇬🇧")
        XCTAssertEqual(PetLanguage.de.flag, "🇩🇪")
        XCTAssertEqual(PetLanguage.sv.flag, "🇸🇪")
    }
    
    func testPetLanguageRawValues() {
        XCTAssertEqual(PetLanguage.nl.rawValue, "nl")
        XCTAssertEqual(PetLanguage.en.rawValue, "en")
        
        // Test round-trip
        XCTAssertEqual(PetLanguage(rawValue: "nl"), .nl)
        XCTAssertEqual(PetLanguage(rawValue: "en"), .en)
        XCTAssertNil(PetLanguage(rawValue: "invalid"))
    }
    
    // MARK: - PetStyle Tests
    
    func testPetStyleAllCases() {
        // Should have exactly 7 styles
        XCTAssertEqual(PetStyle.allCases.count, 7)
    }
    
    func testPetStyleIcons() {
        XCTAssertEqual(PetStyle.cute.icon, "heart.fill")
        XCTAssertEqual(PetStyle.strong.icon, "bolt.fill")
        XCTAssertEqual(PetStyle.classic.icon, "book.fill")
        XCTAssertEqual(PetStyle.funny.icon, "face.smiling.fill")
        XCTAssertEqual(PetStyle.vintage.icon, "clock.fill")
        XCTAssertEqual(PetStyle.nature.icon, "leaf.fill")
        XCTAssertEqual(PetStyle.petnicknames.icon, "star.fill")
    }
    
    func testPetStyleIconColors() {
        // Each style should have a valid hex color
        for style in PetStyle.allCases {
            XCTAssertFalse(style.iconColorHex.isEmpty, "\(style) should have an icon color")
            XCTAssertEqual(style.iconColorHex.count, 6, "\(style) color should be 6 hex chars")
        }
    }
    
    func testPetStyleDisplayName() {
        // DisplayName should not be empty
        for style in PetStyle.allCases {
            XCTAssertFalse(style.displayName.isEmpty, "\(style) should have a display name")
        }
    }
    
    func testPetStyleSubtitle() {
        // Subtitle should not be empty
        for style in PetStyle.allCases {
            XCTAssertFalse(style.subtitle.isEmpty, "\(style) should have a subtitle")
        }
    }
    
    // MARK: - Classification Tests
    
    func testClassifyWithDBFields() {
        // NameSet with language/style fields should be classified correctly
        let set = makeNameSet(language: "nl", style: "cute")
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.language, .nl)
        XCTAssertEqual(result?.style, .cute)
    }
    
    func testClassifyWithSlugFallback() {
        // NameSet without DB fields should fall back to slug parsing
        let set = makeNameSet(slug: "pets_en_strong", language: nil, style: nil)
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.language, .en)
        XCTAssertEqual(result?.style, .strong)
    }
    
    func testClassifyInvalidSet() {
        // NameSet with invalid/missing data should return nil
        let set = makeNameSet(slug: "invalid-slug", language: nil, style: nil)
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNil(result)
    }
    
    func testClassifyAllLanguagesAndStyles() {
        // Test all combinations
        for language in PetLanguage.allCases {
            for style in PetStyle.allCases {
                let set = makeNameSet(language: language.rawValue, style: style.rawValue)
                
                let result = NameSetClassifier.classify(set)
                XCTAssertNotNil(result, "Should classify \(language.rawValue)_\(style.rawValue)")
                XCTAssertEqual(result?.language, language)
                XCTAssertEqual(result?.style, style)
            }
        }
    }
    
    // MARK: - Batch Operations Tests
    
    func testSetsForLanguage() {
        let sets = [
            makeNameSet(language: "nl", style: "cute"),
            makeNameSet(language: "en", style: "cute"),
            makeNameSet(language: "nl", style: "strong"),
        ]
        
        let nlSets = NameSetClassifier.sets(for: .nl, from: sets)
        XCTAssertEqual(nlSets.count, 2)
        
        let enSets = NameSetClassifier.sets(for: .en, from: sets)
        XCTAssertEqual(enSets.count, 1)
        
        let deSets = NameSetClassifier.sets(for: .de, from: sets)
        XCTAssertEqual(deSets.count, 0)
    }
    
    func testSetIdsForLanguageAndStyles() {
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        
        let sets = [
            makeNameSet(id: id1, language: "nl", style: "cute"),
            makeNameSet(id: id2, language: "nl", style: "strong"),
            makeNameSet(id: id3, language: "nl", style: "funny"),
        ]
        
        // Only cute enabled
        let cuteIds = NameSetClassifier.setIds(for: .nl, enabledStyles: [.cute], from: sets)
        XCTAssertEqual(cuteIds.count, 1)
        XCTAssertTrue(cuteIds.contains(id1))
        
        // Cute and strong enabled
        let multiIds = NameSetClassifier.setIds(for: .nl, enabledStyles: [.cute, .strong], from: sets)
        XCTAssertEqual(multiIds.count, 2)
        
        // No styles enabled
        let emptyIds = NameSetClassifier.setIds(for: .nl, enabledStyles: [], from: sets)
        XCTAssertEqual(emptyIds.count, 0)
    }
    
    func testAvailableStyles() {
        let sets = [
            makeNameSet(language: "nl", style: "cute"),
            makeNameSet(language: "nl", style: "strong"),
            makeNameSet(language: "en", style: "funny"),
        ]
        
        let nlStyles = NameSetClassifier.availableStyles(for: .nl, from: sets)
        XCTAssertEqual(nlStyles.count, 2)
        XCTAssertTrue(nlStyles.contains(.cute))
        XCTAssertTrue(nlStyles.contains(.strong))
        XCTAssertFalse(nlStyles.contains(.funny))
        
        let enStyles = NameSetClassifier.availableStyles(for: .en, from: sets)
        XCTAssertEqual(enStyles.count, 1)
        XCTAssertTrue(enStyles.contains(.funny))
    }
    
    func testAvailableLanguages() {
        let sets = [
            makeNameSet(language: "nl", style: "cute"),
            makeNameSet(language: "en", style: "cute"),
        ]
        
        let languages = NameSetClassifier.availableLanguages(from: sets)
        XCTAssertEqual(languages.count, 2)
        XCTAssertTrue(languages.contains(.nl))
        XCTAssertTrue(languages.contains(.en))
        XCTAssertFalse(languages.contains(.de))
    }
    
    // MARK: - Test Helpers
    
    private func makeNameSet(
        id: UUID = UUID(),
        slug: String = "test-slug",
        title: String = "Test",
        language: String?,
        style: String?
    ) -> NameSet {
        NameSet(
            id: id,
            slug: slug,
            title: title,
            isFree: true,
            language: language,
            style: style,
            description: nil
        )
    }
}

// MARK: - Models Tests

final class ModelsTests: XCTestCase {
    
    // MARK: - NameSet Tests
    
    func testNameSetCodable() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "slug": "test-slug",
            "title": "Test Title",
            "is_free": true,
            "language": "en",
            "style": "cute",
            "description": "Test description"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let set = try decoder.decode(NameSet.self, from: json)
        
        XCTAssertEqual(set.slug, "test-slug")
        XCTAssertEqual(set.title, "Test Title")
        XCTAssertEqual(set.isFree, true)
        XCTAssertEqual(set.language, "en")
        XCTAssertEqual(set.style, "cute")
        XCTAssertEqual(set.description, "Test description")
    }
    
    func testNameSetCodableWithNulls() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "slug": "test-slug",
            "title": "Test Title",
            "is_free": false
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let set = try decoder.decode(NameSet.self, from: json)
        
        XCTAssertEqual(set.slug, "test-slug")
        XCTAssertEqual(set.isFree, false)
        XCTAssertNil(set.language)
        XCTAssertNil(set.style)
        XCTAssertNil(set.description)
    }
    
    // MARK: - NameCard Tests
    
    func testNameCardCodable() throws {
        let json = """
        {
            "name_id": "550e8400-e29b-41d4-a716-446655440000",
            "name": "Luna",
            "gender": "female",
            "set_title": "Cute Names",
            "set_id": "660e8400-e29b-41d4-a716-446655440000"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let card = try decoder.decode(NameCard.self, from: json)
        
        XCTAssertEqual(card.name, "Luna")
        XCTAssertEqual(card.gender, "female")
        XCTAssertEqual(card.setTitle, "Cute Names")
        XCTAssertFalse(card.isLocal) // Default should be false for server names
    }
    
    func testNameCardLocalFlag() {
        let localCard = NameCard(
            id: UUID(),
            name: "Fluffy",
            gender: "neutral",
            setTitle: "Test Set",
            setId: UUID(),
            isLocal: true
        )
        XCTAssertTrue(localCard.isLocal)
        
        let serverCard = NameCard(
            id: UUID(),
            name: "Max",
            gender: "male",
            setTitle: "Server Set",
            setId: UUID(),
            isLocal: false
        )
        XCTAssertFalse(serverCard.isLocal)
    }
    
    func testNameCardDefaultIsLocalFalse() {
        let card = NameCard(
            id: UUID(),
            name: "Buddy",
            gender: "male",
            setTitle: "Test",
            setId: UUID()
        )
        XCTAssertFalse(card.isLocal) // Default should be false
    }
    
    // MARK: - Filters Tests
    
    func testFiltersDefaults() {
        let filters = Filters()
        
        XCTAssertEqual(filters.gender, "any")
        XCTAssertEqual(filters.startsWith, "any")
        XCTAssertEqual(filters.maxLength, 0)
    }
    
    func testFiltersCodable() throws {
        let original = Filters(gender: "female", startsWith: "a", maxLength: 5)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Filters.self, from: data)
        
        XCTAssertEqual(decoded.gender, "female")
        XCTAssertEqual(decoded.startsWith, "a")
        XCTAssertEqual(decoded.maxLength, 5)
    }
    
    // MARK: - HouseholdMember Tests
    
    func testHouseholdMemberDisplayLabel() {
        let memberWithName = HouseholdMember(
            id: UUID(),
            displayName: "John",
            createdAt: nil
        )
        XCTAssertEqual(memberWithName.displayLabel, "John")
        
        let memberWithoutName = HouseholdMember(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
            displayName: nil,
            createdAt: nil
        )
        XCTAssertTrue(memberWithoutName.displayLabel.starts(with: "User "))
    }
    
    // MARK: - SwipeDecision Tests
    
    func testSwipeDecisionRawValues() {
        XCTAssertEqual(SwipeDecision.like.rawValue, "like")
        XCTAssertEqual(SwipeDecision.dismiss.rawValue, "dismiss")
    }
}

// MARK: - Filters Tests

final class FiltersTests: XCTestCase {
    
    func testFiltersWithAllOptions() {
        let filters = Filters(gender: "male", startsWith: "j", maxLength: 10)
        
        XCTAssertEqual(filters.gender, "male")
        XCTAssertEqual(filters.startsWith, "j")
        XCTAssertEqual(filters.maxLength, 10)
    }
    
    func testFiltersGenderValues() {
        // Test all valid gender values
        let validGenders = ["any", "male", "female", "neutral"]
        
        for gender in validGenders {
            let filters = Filters(gender: gender, startsWith: "any", maxLength: 0)
            XCTAssertEqual(filters.gender, gender)
        }
    }
    
    func testFiltersStartsWithValues() {
        // Test "any" and all letters
        let anyFilters = Filters(gender: "any", startsWith: "any", maxLength: 0)
        XCTAssertEqual(anyFilters.startsWith, "any")
        
        for letter in "abcdefghijklmnopqrstuvwxyz" {
            let filters = Filters(gender: "any", startsWith: String(letter), maxLength: 0)
            XCTAssertEqual(filters.startsWith, String(letter))
        }
    }
    
    func testFiltersMaxLengthBoundaries() {
        // Zero means no limit
        let noLimit = Filters(gender: "any", startsWith: "any", maxLength: 0)
        XCTAssertEqual(noLimit.maxLength, 0)
        
        // Typical values
        let short = Filters(gender: "any", startsWith: "any", maxLength: 3)
        XCTAssertEqual(short.maxLength, 3)
        
        let long = Filters(gender: "any", startsWith: "any", maxLength: 20)
        XCTAssertEqual(long.maxLength, 20)
    }
}

// MARK: - LocalNamesProvider Tests

final class LocalNamesProviderTests: XCTestCase {
    
    func testLocalNameEntryProperties() {
        let entry = LocalNameEntry(
            name: "Luna",
            gender: "female",
            setSlug: "pets_en_cute",
            setTitle: "Cute & Sweet",
            language: "en",
            style: "cute"
        )
        
        XCTAssertEqual(entry.name, "Luna")
        XCTAssertEqual(entry.gender, "female")
        XCTAssertEqual(entry.setSlug, "pets_en_cute")
        XCTAssertEqual(entry.setTitle, "Cute & Sweet")
        XCTAssertEqual(entry.language, "en")
        XCTAssertEqual(entry.style, "cute")
    }
    
    func testBundledNameCodable() throws {
        let json = """
        {"name": "Max", "gender": "male"}
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let name = try decoder.decode(BundledName.self, from: json)
        
        XCTAssertEqual(name.name, "Max")
        XCTAssertEqual(name.gender, "male")
    }
    
    func testBundledNameSetCodable() throws {
        let json = """
        {
            "slug": "pets_nl_cute",
            "title": "Lief & Schattig",
            "description": "Test description",
            "language": "nl",
            "style": "cute",
            "names": [
                {"name": "Luna", "gender": "female"},
                {"name": "Max", "gender": "male"}
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let set = try decoder.decode(BundledNameSet.self, from: json)
        
        XCTAssertEqual(set.slug, "pets_nl_cute")
        XCTAssertEqual(set.title, "Lief & Schattig")
        XCTAssertEqual(set.language, "nl")
        XCTAssertEqual(set.style, "cute")
        XCTAssertEqual(set.names.count, 2)
    }
    
    func testBundledNamesDataCodable() throws {
        let json = """
        {
            "version": 1,
            "lastUpdated": "2026-01-28T00:00:00Z",
            "nameSets": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let data = try decoder.decode(BundledNamesData.self, from: json)
        
        XCTAssertEqual(data.version, 1)
        XCTAssertEqual(data.lastUpdated, "2026-01-28T00:00:00Z")
        XCTAssertEqual(data.nameSets.count, 0)
    }
}

// MARK: - Edge Cases Tests

final class EdgeCaseTests: XCTestCase {
    
    // MARK: - Empty Data Tests
    
    func testEmptyNameSetsArray() {
        let emptyLanguages = NameSetClassifier.availableLanguages(from: [])
        XCTAssertTrue(emptyLanguages.isEmpty)
        
        let emptyStyles = NameSetClassifier.availableStyles(for: .en, from: [])
        XCTAssertTrue(emptyStyles.isEmpty)
        
        let emptyIds = NameSetClassifier.setIds(for: .en, enabledStyles: [.cute], from: [])
        XCTAssertTrue(emptyIds.isEmpty)
    }
    
    func testEmptyStylesSet() {
        let sets = [
            makeTestNameSet(language: "nl", style: "cute"),
        ]
        
        // No styles enabled should return empty
        let ids = NameSetClassifier.setIds(for: .nl, enabledStyles: [], from: sets)
        XCTAssertTrue(ids.isEmpty)
    }
    
    // MARK: - Boundary Tests
    
    func testVeryLongName() {
        let longName = String(repeating: "a", count: 100)
        let entry = LocalNameEntry(
            name: longName,
            gender: "neutral",
            setSlug: "test",
            setTitle: "Test",
            language: "en",
            style: "cute"
        )
        
        XCTAssertEqual(entry.name.count, 100)
    }
    
    func testSpecialCharactersInName() {
        let specialNames = ["José", "François", "Müller", "O'Brien", "Anne-Marie"]
        
        for name in specialNames {
            let entry = LocalNameEntry(
                name: name,
                gender: "neutral",
                setSlug: "test",
                setTitle: "Test",
                language: "en",
                style: "cute"
            )
            XCTAssertEqual(entry.name, name)
        }
    }
    
    func testUnicodeInName() {
        let unicodeNames = ["日本", "中文", "한국어", "العربية", "🐱"]
        
        for name in unicodeNames {
            let entry = LocalNameEntry(
                name: name,
                gender: "neutral",
                setSlug: "test",
                setTitle: "Test",
                language: "en",
                style: "cute"
            )
            XCTAssertEqual(entry.name, name)
        }
    }
    
    // MARK: - Case Sensitivity Tests
    
    func testLanguageRawValueCaseSensitivity() {
        XCTAssertNotNil(PetLanguage(rawValue: "nl"))
        XCTAssertNil(PetLanguage(rawValue: "NL"))
        XCTAssertNil(PetLanguage(rawValue: "Nl"))
    }
    
    func testStyleRawValueCaseSensitivity() {
        XCTAssertNotNil(PetStyle(rawValue: "cute"))
        XCTAssertNil(PetStyle(rawValue: "CUTE"))
        XCTAssertNil(PetStyle(rawValue: "Cute"))
    }
    
    // MARK: - UUID Tests
    
    func testNameSetIdIsValid() {
        let id = UUID()
        let set = NameSet(
            id: id,
            slug: "test",
            title: "Test",
            isFree: true,
            language: "en",
            style: "cute",
            description: nil
        )
        
        XCTAssertEqual(set.id, id)
    }
    
    // MARK: - Duplicate Handling
    
    func testDuplicateNameSets() {
        let id = UUID()
        let sets = [
            makeTestNameSet(id: id, language: "nl", style: "cute"),
            makeTestNameSet(id: id, language: "nl", style: "cute"),
        ]
        
        // Should return both (no deduplication at this level)
        let nlSets = NameSetClassifier.sets(for: .nl, from: sets)
        XCTAssertEqual(nlSets.count, 2)
    }
    
    // MARK: - Nil Safety Tests
    
    func testNameSetWithAllNilOptionals() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "slug": "test",
            "title": "Test",
            "is_free": true
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let set = try decoder.decode(NameSet.self, from: json)
        
        XCTAssertNil(set.language)
        XCTAssertNil(set.style)
        XCTAssertNil(set.description)
    }
    
    // MARK: - Test Helper
    
    private func makeTestNameSet(
        id: UUID = UUID(),
        slug: String = "test",
        title: String = "Test",
        language: String?,
        style: String?
    ) -> NameSet {
        NameSet(
            id: id,
            slug: slug,
            title: title,
            isFree: true,
            language: language,
            style: style,
            description: nil
        )
    }
}

// MARK: - Color Extension Tests

final class ColorExtensionTests: XCTestCase {
    
    func testValidHexColors() {
        // These should not crash
        let _ = Color(hex: "FF0000")  // Red
        let _ = Color(hex: "00FF00")  // Green
        let _ = Color(hex: "0000FF")  // Blue
        let _ = Color(hex: "FFFFFF")  // White
        let _ = Color(hex: "000000")  // Black
        let _ = Color(hex: "667eea")  // App accent
    }
    
    func testLowercaseHex() {
        // Should handle lowercase hex
        let _ = Color(hex: "ff0000")
        let _ = Color(hex: "aabbcc")
    }
}

// MARK: - Classification Edge Cases

final class ClassificationEdgeCaseTests: XCTestCase {
    
    func testOldSlugFormat() {
        // Test legacy slug format: {language-prefix}-{style}
        let set = makeSet(slug: "dutch-cute", language: nil, style: nil)
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.language, .nl)
        XCTAssertEqual(result?.style, .cute)
    }
    
    func testMixedSlugAndDBFields() {
        // DB fields should take precedence over slug
        let set = makeSet(slug: "pets_nl_cute", language: "en", style: "strong")
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.language, .en)     // Should use DB field
        XCTAssertEqual(result?.style, .strong)    // Should use DB field
    }
    
    func testPartialDBFields() {
        // Only language set, no style - should fail
        let set = makeSet(slug: "invalid", language: "en", style: nil)
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNil(result)
    }
    
    func testInvalidLanguageInDB() {
        let set = makeSet(slug: "invalid", language: "invalid_lang", style: "cute")
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNil(result)
    }
    
    func testInvalidStyleInDB() {
        let set = makeSet(slug: "invalid", language: "en", style: "invalid_style")
        
        let result = NameSetClassifier.classify(set)
        XCTAssertNil(result)
    }
    
    // MARK: - Test Helper
    
    private func makeSet(
        slug: String,
        language: String?,
        style: String?
    ) -> NameSet {
        NameSet(
            id: UUID(),
            slug: slug,
            title: "Test",
            isFree: true,
            language: language,
            style: style,
            description: nil
        )
    }
}
