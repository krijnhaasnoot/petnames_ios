//
//  NameSetClassifier.swift
//  petnames
//
//  Petnames by Kinder - POC
//  Maps name sets to language + style for clean UI filtering
//

import Foundation
import SwiftUI

// MARK: - Pet Language

/// Supported languages for pet names
enum PetLanguage: String, CaseIterable, Codable, Sendable, Identifiable {
    case nl = "nl"
    case en = "en"
    case de = "de"
    case fr = "fr"
    case es = "es"
    case it = "it"
    case sv = "sv"
    case no = "no"
    case da = "da"
    case fi = "fi"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .nl: return "Nederlands"
        case .en: return "English"
        case .de: return "Deutsch"
        case .fr: return "Français"
        case .es: return "Español"
        case .it: return "Italiano"
        case .sv: return "Svenska"
        case .no: return "Norsk"
        case .da: return "Dansk"
        case .fi: return "Suomi"
        }
    }
    
    /// Short display name for segmented control
    var shortName: String {
        switch self {
        case .nl: return "NL"
        case .en: return "EN"
        case .de: return "DE"
        case .fr: return "FR"
        case .es: return "ES"
        case .it: return "IT"
        case .sv: return "SV"
        case .no: return "NO"
        case .da: return "DA"
        case .fi: return "FI"
        }
    }
    
    /// Flag emoji for the language
    var flag: String {
        switch self {
        case .nl: return "🇳🇱"
        case .en: return "🇬🇧"
        case .de: return "🇩🇪"
        case .fr: return "🇫🇷"
        case .es: return "🇪🇸"
        case .it: return "🇮🇹"
        case .sv: return "🇸🇪"
        case .no: return "🇳🇴"
        case .da: return "🇩🇰"
        case .fi: return "🇫🇮"
        }
    }
    
    /// Slug prefix used in database
    var slugPrefix: String {
        switch self {
        case .nl: return "dutch"
        case .en: return "english"
        case .de: return "german"
        case .fr: return "french"
        case .es: return "spanish"
        case .it: return "italian"
        case .sv: return "swedish"
        case .no: return "norwegian"
        case .da: return "danish"
        case .fi: return "finnish"
        }
    }
}

// MARK: - Pet Style

/// Style categories for pet names (same for all languages)
enum PetStyle: String, CaseIterable, Codable, Sendable {
    case cute = "cute"
    case strong = "strong"
    case classic = "classic"
    case funny = "funny"
    case vintage = "vintage"
    case nature = "nature"
    case petnicknames = "petnicknames"
    
    /// Localized display name
    var displayName: String {
        String(localized: localizationKey)
    }
    
    /// Localized subtitle description
    var subtitle: String {
        String(localized: subtitleKey)
    }
    
    /// Localization key for the style name
    private var localizationKey: String.LocalizationValue {
        switch self {
        case .cute: return "style.cute"
        case .strong: return "style.strong"
        case .classic: return "style.classic"
        case .funny: return "style.funny"
        case .vintage: return "style.vintage"
        case .nature: return "style.nature"
        case .petnicknames: return "style.petnicknames"
        }
    }
    
    /// Localization key for the subtitle
    private var subtitleKey: String.LocalizationValue {
        switch self {
        case .cute: return "style.cute.subtitle"
        case .strong: return "style.strong.subtitle"
        case .classic: return "style.classic.subtitle"
        case .funny: return "style.funny.subtitle"
        case .vintage: return "style.vintage.subtitle"
        case .nature: return "style.nature.subtitle"
        case .petnicknames: return "style.petnicknames.subtitle"
        }
    }
    
    /// Display title based on language
    func title(for language: PetLanguage) -> String {
        switch language {
        case .nl:
            switch self {
            case .cute: return "Lief & Schattig"
            case .strong: return "Kort & Stoer"
            case .classic: return "Klassiek"
            case .funny: return "Speels & Grappig"
            case .vintage: return "Nostalgisch"
            case .nature: return "Natuur"
            case .petnicknames: return "Koosnamen"
            }
        case .en:
            switch self {
            case .cute: return "Cute & Sweet"
            case .strong: return "Short & Strong"
            case .classic: return "Classic"
            case .funny: return "Funny & Playful"
            case .vintage: return "Vintage"
            case .nature: return "Nature Inspired"
            case .petnicknames: return "Pet Nicknames"
            }
        case .de:
            switch self {
            case .cute: return "Süß & Liebevoll"
            case .strong: return "Kurz & Stark"
            case .classic: return "Klassisch"
            case .funny: return "Lustig & Verspielt"
            case .vintage: return "Nostalgisch"
            case .nature: return "Natur"
            case .petnicknames: return "Kosenamen"
            }
        case .fr:
            switch self {
            case .cute: return "Mignon & Doux"
            case .strong: return "Court & Fort"
            case .classic: return "Classique"
            case .funny: return "Drôle & Joueur"
            case .vintage: return "Rétro"
            case .nature: return "Nature"
            case .petnicknames: return "Surnoms"
            }
        case .es:
            switch self {
            case .cute: return "Lindo & Dulce"
            case .strong: return "Corto & Fuerte"
            case .classic: return "Clásico"
            case .funny: return "Divertido"
            case .vintage: return "Vintage"
            case .nature: return "Naturaleza"
            case .petnicknames: return "Apodos"
            }
        case .it:
            switch self {
            case .cute: return "Carino & Dolce"
            case .strong: return "Corto & Forte"
            case .classic: return "Classico"
            case .funny: return "Divertente"
            case .vintage: return "Vintage"
            case .nature: return "Natura"
            case .petnicknames: return "Soprannomi"
            }
        case .sv:
            switch self {
            case .cute: return "Gullig & Söt"
            case .strong: return "Kort & Stark"
            case .classic: return "Klassisk"
            case .funny: return "Rolig & Lekfull"
            case .vintage: return "Nostalgisk"
            case .nature: return "Natur"
            case .petnicknames: return "Smeknamn"
            }
        case .no:
            switch self {
            case .cute: return "Søt & Koselig"
            case .strong: return "Kort & Sterk"
            case .classic: return "Klassisk"
            case .funny: return "Morsom & Leken"
            case .vintage: return "Nostalgisk"
            case .nature: return "Natur"
            case .petnicknames: return "Kallenavn"
            }
        case .da:
            switch self {
            case .cute: return "Sød & Nuttet"
            case .strong: return "Kort & Stærk"
            case .classic: return "Klassisk"
            case .funny: return "Sjov & Legende"
            case .vintage: return "Nostalgisk"
            case .nature: return "Natur"
            case .petnicknames: return "Kælenavne"
            }
        case .fi:
            switch self {
            case .cute: return "Söpö & Suloinen"
            case .strong: return "Lyhyt & Vahva"
            case .classic: return "Klassinen"
            case .funny: return "Hauska & Leikkisä"
            case .vintage: return "Nostalginen"
            case .nature: return "Luonto"
            case .petnicknames: return "Lempinimet"
            }
        }
    }
    
    /// SF Symbol icon name
    var icon: String {
        switch self {
        case .cute: return "heart.fill"
        case .strong: return "bolt.fill"
        case .classic: return "book.fill"
        case .funny: return "face.smiling.fill"
        case .vintage: return "clock.fill"
        case .nature: return "leaf.fill"
        case .petnicknames: return "star.fill"
        }
    }
    
    /// Icon tint color
    var iconColorHex: String {
        switch self {
        case .cute: return "ec4899"      // Pink
        case .strong: return "f97316"    // Orange
        case .classic: return "92400e"   // Brown
        case .funny: return "eab308"     // Yellow
        case .vintage: return "a855f7"   // Purple
        case .nature: return "22c55e"    // Green
        case .petnicknames: return "3b82f6" // Blue
        }
    }
}

// MARK: - Classification Result

/// Result of classifying a name set
struct NameSetClassification: Equatable, Sendable {
    let language: PetLanguage
    let style: PetStyle
}

// MARK: - Name Set Classifier

/// Classifies name sets by language and style
/// Prefers using DB fields (language, style) with fallback to slug parsing
enum NameSetClassifier {
    
    /// Classify a name set into (language, style)
    /// Returns nil if the set cannot be classified
    static func classify(_ set: NameSet) -> NameSetClassification? {
        // Prefer DB fields if available
        if let langStr = set.language,
           let styleStr = set.style,
           let language = PetLanguage(rawValue: langStr),
           let style = PetStyle(rawValue: styleStr) {
            return NameSetClassification(language: language, style: style)
        }
        
        // Fallback to slug-based classification for legacy data
        let slug = set.slug.lowercased().trimmingCharacters(in: .whitespaces)
        return classifyBySlug(slug)
    }
    
    /// Slug-based classification (fallback for legacy data)
    /// Format expected: pets_{language}_{style} or {language-prefix}-{style}
    private static func classifyBySlug(_ slug: String) -> NameSetClassification? {
        // Try new format: pets_{language}_{style}
        if slug.hasPrefix("pets_") {
            let parts = slug.dropFirst(5).split(separator: "_")
            if parts.count >= 2 {
                let langPart = String(parts[0])
                let stylePart = String(parts[1])
                if let language = PetLanguage(rawValue: langPart),
                   let style = PetStyle(rawValue: stylePart) {
                    return NameSetClassification(language: language, style: style)
                }
            }
        }
        
        // Try old format: {language-prefix}-{style}
        for language in PetLanguage.allCases {
            let prefix = language.slugPrefix + "-"
            if slug.hasPrefix(prefix) {
                let stylePart = String(slug.dropFirst(prefix.count))
                if let style = matchStyle(stylePart) {
                    return NameSetClassification(language: language, style: style)
                }
            }
        }
        
        return nil
    }
    
    /// Match a style string to PetStyle (for legacy slug parsing)
    private static func matchStyle(_ stylePart: String) -> PetStyle? {
        switch stylePart {
        case "cute", "sweet", "lief":
            return .cute
        case "strong", "tough", "stoer":
            return .strong
        case "classic", "klassiek":
            return .classic
        case "funny", "playful", "grappig":
            return .funny
        case "vintage", "nostalgic", "old-school", "oud-hollands":
            return .vintage
        case "nature", "natuur":
            return .nature
        case "petnicknames", "nicknames", "koosnamen":
            return .petnicknames
        default:
            return nil
        }
    }
    
    // MARK: - Batch Operations
    
    /// Get all sets for a specific language
    static func sets(for language: PetLanguage, from sets: [NameSet]) -> [NameSet] {
        sets.filter { classify($0)?.language == language }
    }
    
    /// Get set IDs for a language and enabled styles
    static func setIds(
        for language: PetLanguage,
        enabledStyles: Set<PetStyle>,
        from sets: [NameSet]
    ) -> [UUID] {
        sets.compactMap { set in
            guard let classification = classify(set),
                  classification.language == language,
                  enabledStyles.contains(classification.style) else {
                return nil
            }
            return set.id
        }
    }
    
    /// Get set IDs for multiple languages and enabled styles
    static func setIds(
        for languages: Set<PetLanguage>,
        enabledStyles: [PetLanguage: Set<PetStyle>],
        from sets: [NameSet]
    ) -> [UUID] {
        sets.compactMap { set in
            guard let classification = classify(set),
                  languages.contains(classification.language),
                  let styles = enabledStyles[classification.language],
                  styles.contains(classification.style) else {
                return nil
            }
            return set.id
        }
    }
    
    /// Get available styles for a language (styles that have at least one set)
    static func availableStyles(for language: PetLanguage, from sets: [NameSet]) -> Set<PetStyle> {
        var styles = Set<PetStyle>()
        for set in sets {
            if let classification = classify(set), classification.language == language {
                styles.insert(classification.style)
            }
        }
        return styles
    }
    
    /// Get available languages (languages that have at least one set)
    static func availableLanguages(from sets: [NameSet]) -> Set<PetLanguage> {
        var languages = Set<PetLanguage>()
        for set in sets {
            if let classification = classify(set) {
                languages.insert(classification.language)
            }
        }
        return languages
    }
    
    /// Map sets to their classifications
    static func classifyAll(_ sets: [NameSet]) -> [(set: NameSet, classification: NameSetClassification)] {
        sets.compactMap { set in
            guard let classification = classify(set) else { return nil }
            return (set, classification)
        }
    }
}
