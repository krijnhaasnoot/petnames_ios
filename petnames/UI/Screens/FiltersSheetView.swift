//
//  FiltersSheetView.swift
//  petnames
//
//  Petnames by Kinder - POC
//  Multi-language support with unified style selection
//

import SwiftUI

struct FiltersSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var appState = AppState.shared
    
    // Local state for editing (applied on save)
    @State private var selectedLanguages: Set<PetLanguage>
    @State private var enabledStyles: Set<PetStyle>
    @State private var selectedGender: String
    @State private var selectedStartsWith: String
    @State private var maxLength: Int
    
    // Sheet states
    @State private var showLanguagePicker = false
    
    let onDismiss: () -> Void
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        let state = AppState.shared
        _selectedLanguages = State(initialValue: state.selectedLanguages)
        _enabledStyles = State(initialValue: state.enabledStyles)
        _selectedGender = State(initialValue: state.filters.gender)
        _selectedStartsWith = State(initialValue: state.filters.startsWith)
        _maxLength = State(initialValue: state.filters.maxLength)
    }
    
    // MARK: - Computed Properties
    
    /// Sorted selected languages for display
    private var sortedSelectedLanguages: [PetLanguage] {
        PetLanguage.allCases.filter { selectedLanguages.contains($0) }
    }
    
    /// Available styles across all selected languages
    private var availableStyles: [PetStyle] {
        var styles = Set<PetStyle>()
        for language in selectedLanguages {
            styles.formUnion(NameSetClassifier.availableStyles(for: language, from: appState.nameSets))
        }
        return PetStyle.allCases.filter { styles.contains($0) }
    }
    
    /// Check if all styles are enabled
    private var allStylesEnabled: Bool {
        let available = Set(availableStyles)
        guard !available.isEmpty else { return false }
        return available.isSubset(of: enabledStyles)
    }
    
    /// Check if no styles are enabled
    private var noStylesEnabled: Bool {
        enabledStyles.isEmpty || !enabledStyles.contains(where: { availableStyles.contains($0) })
    }
    
    /// Status text for styles
    private var stylesStatusText: String {
        let enabledCount = availableStyles.filter { enabledStyles.contains($0) }.count
        let totalCount = availableStyles.count
        
        if enabledCount == totalCount {
            return String(localized: "filters.allCategories")
        } else if enabledCount == 0 {
            return String(localized: "filters.noCategoriesSelected")
        } else {
            return "\(enabledCount) / \(totalCount)"
        }
    }
    
    /// Language selection summary text
    private var languageSummaryText: String {
        if selectedLanguages.count == 1 {
            return selectedLanguages.first?.displayName ?? ""
        } else if selectedLanguages.count == PetLanguage.allCases.count {
            return String(localized: "languages.allLanguages")
        } else {
            return "\(selectedLanguages.count)"
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Language Section
                languageSection
                
                // MARK: Style Categories Section
                styleCategoriesSection
                
                // MARK: Other Filters Section
                otherFiltersSection
                
                // MARK: Reset Section
                resetSection
            }
            .navigationTitle(String(localized: "filters.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "filters.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "filters.apply")) {
                        saveFilters()
                        dismiss()
                        onDismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(noStylesEnabled || selectedLanguages.isEmpty)
                }
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerSheet(selectedLanguages: $selectedLanguages)
            }
        }
        .presentationDetents([.large])
    }
    
    // MARK: - Language Section
    
    private var languageSection: some View {
        Section {
            // Language picker button
            Button {
                showLanguagePicker = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("filters.languages", comment: "Languages")
                            .foregroundStyle(.primary)
                        Text(languageSummaryText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // Show selected language flags
                    HStack(spacing: 4) {
                        ForEach(sortedSelectedLanguages.prefix(6), id: \.self) { language in
                            Text(language.flag)
                                .font(.title3)
                        }
                        if sortedSelectedLanguages.count > 6 {
                            Text("+\(sortedSelectedLanguages.count - 6)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("filters.namesFrom", comment: "Names from")
        } footer: {
            Text("filters.chooseLanguages", comment: "Choose which languages")
        }
    }
    
    // MARK: - Style Categories Section
    
    private var styleCategoriesSection: some View {
        Section {
            // Status row with select all / deselect all buttons
            HStack {
                Text(stylesStatusText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if allStylesEnabled {
                    Button("filters.deselectAll") {
                        deselectAllStyles()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "667eea"))
                } else {
                    Button("filters.selectAll") {
                        selectAllStyles()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "667eea"))
                }
            }
            .listRowBackground(Color(UIColor.secondarySystemGroupedBackground).opacity(0.5))
            
            // Style toggle rows
            if availableStyles.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("filters.noCategoriesSelected")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ForEach(availableStyles, id: \.self) { style in
                    StyleToggleRow(
                        style: style,
                        isEnabled: enabledStyles.contains(style),
                        onToggle: { enabled in
                            toggleStyle(style, enabled: enabled)
                        }
                    )
                }
            }
        } header: {
            Text("filters.categories")
        } footer: {
            if noStylesEnabled && !availableStyles.isEmpty {
                Text("filters.selectAtLeastOne")
                    .foregroundStyle(.red)
            } else {
                Text("filters.categoriesApplyToAll")
            }
        }
    }
    
    // MARK: - Other Filters Section
    
    private var otherFiltersSection: some View {
        Section("filters.otherFilters") {
            // Gender picker
            Picker("filters.gender", selection: $selectedGender) {
                Text("filters.genderAny").tag("any")
                Text("filters.genderMale").tag("male")
                Text("filters.genderFemale").tag("female")
            }
            .pickerStyle(.segmented)
            
            // Gender explanation
            if selectedGender != "any" {
                Text(selectedGender == "male" 
                    ? "filters.genderMaleHint" 
                    : "filters.genderFemaleHint")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Starts with
            Picker("filters.startsWith", selection: $selectedStartsWith) {
                Text("filters.any").tag("any")
                ForEach(Array("abcdefghijklmnopqrstuvwxyz"), id: \.self) { letter in
                    Text(String(letter).uppercased()).tag(String(letter))
                }
            }
            
            // Max length
            HStack {
                Text("filters.maxLength")
                
                Spacer()
                
                Text(maxLength == 0 ? String(localized: "filters.allLengths") : "Max \(maxLength)")
                    .foregroundStyle(.secondary)
                
                Stepper("", value: $maxLength, in: 0...20)
                    .labelsHidden()
                    .frame(width: 94)
            }
        }
    }
    
    // MARK: - Reset Section
    
    private var resetSection: some View {
        Section {
            Button("filters.resetDefaults") {
                resetToDefaults()
            }
            .foregroundStyle(.red)
        }
    }
    
    // MARK: - Actions
    
    private func toggleStyle(_ style: PetStyle, enabled: Bool) {
        if enabled {
            enabledStyles.insert(style)
        } else {
            enabledStyles.remove(style)
        }
    }
    
    private func selectAllStyles() {
        enabledStyles = Set(availableStyles)
    }
    
    private func deselectAllStyles() {
        enabledStyles = []
    }
    
    private func resetToDefaults() {
        selectedLanguages = [.nl, .en]
        enabledStyles = Set(PetStyle.allCases)
        selectedGender = "any"
        selectedStartsWith = "any"
        maxLength = 0
    }
    
    private func saveFilters() {
        // Track analytics for filter changes
        let oldLanguages = appState.selectedLanguages
        let oldStyles = appState.enabledStyles
        let oldFilters = appState.filters
        
        // Track language changes
        if selectedLanguages != oldLanguages {
            AnalyticsManager.shared.trackLanguagesSelected(
                languages: selectedLanguages.map { $0.rawValue }
            )
        }
        
        // Track style changes
        if enabledStyles != oldStyles {
            AnalyticsManager.shared.trackStylesEnabled(
                styles: enabledStyles.map { $0.rawValue }
            )
        }
        
        // Track individual filter changes
        if selectedGender != oldFilters.gender {
            AnalyticsManager.shared.trackFilterChanged(filterType: "gender", value: selectedGender)
        }
        if selectedStartsWith != oldFilters.startsWith {
            AnalyticsManager.shared.trackFilterChanged(filterType: "starts_with", value: selectedStartsWith)
        }
        if maxLength != oldFilters.maxLength {
            AnalyticsManager.shared.trackFilterChanged(filterType: "max_length", value: String(maxLength))
        }
        
        // Save languages & styles
        appState.selectedLanguages = selectedLanguages
        appState.enabledStyles = enabledStyles
        appState.saveLanguageSettings()
        
        // Save other filters
        appState.filters = Filters(
            gender: selectedGender,
            startsWith: selectedStartsWith,
            maxLength: maxLength
        )
        appState.saveFilters()
        
        // Recompute enabled set IDs
        appState.recomputeEnabledSetIds()
    }
}

// MARK: - Style Toggle Row

struct StyleToggleRow: View {
    let style: PetStyle
    let isEnabled: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isEnabled },
            set: { onToggle($0) }
        )) {
            HStack(spacing: 12) {
                // Icon with colored background
                ZStack {
                    Circle()
                        .fill(Color(hex: style.iconColorHex).opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: style.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(hex: style.iconColorHex))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(style.displayName)
                        .font(.body)
                    Text(style.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .tint(Color(hex: "667eea"))
    }
}

// MARK: - Language Picker Sheet

struct LanguagePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLanguages: Set<PetLanguage>
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(PetLanguage.allCases, id: \.self) { language in
                        LanguageRow(
                            language: language,
                            isSelected: selectedLanguages.contains(language),
                            isOnlySelected: selectedLanguages.count == 1 && selectedLanguages.contains(language),
                            onToggle: { selected in
                                toggleLanguage(language, selected: selected)
                            }
                        )
                    }
                } header: {
                    Text("languages.available")
                } footer: {
                    Text("languages.footer")
                }
                
                // Quick select buttons
                Section {
                    Button("filters.selectAll") {
                        selectedLanguages = Set(PetLanguage.allCases)
                    }
                    .foregroundStyle(Color(hex: "667eea"))
                    
                    Button("languages.onlyNlEn") {
                        selectedLanguages = [.nl, .en]
                    }
                    .foregroundStyle(Color(hex: "667eea"))
                    
                    Button("languages.onlyScandinavian") {
                        selectedLanguages = [.sv, .no, .da, .fi]
                    }
                    .foregroundStyle(Color(hex: "667eea"))
                }
            }
            .navigationTitle(String(localized: "languages.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("languages.done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func toggleLanguage(_ language: PetLanguage, selected: Bool) {
        if selected {
            selectedLanguages.insert(language)
        } else {
            // Don't allow removing the last language
            if selectedLanguages.count > 1 {
                selectedLanguages.remove(language)
            }
        }
    }
}

// MARK: - Language Row

struct LanguageRow: View {
    let language: PetLanguage
    let isSelected: Bool
    let isOnlySelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isSelected },
            set: { onToggle($0) }
        )) {
            HStack(spacing: 12) {
                Text(language.flag)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.body)
                    
                    Text(language.rawValue.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .tint(Color(hex: "667eea"))
        .disabled(isOnlySelected) // Can't disable the last language
    }
}

#Preview {
    FiltersSheetView {}
}
