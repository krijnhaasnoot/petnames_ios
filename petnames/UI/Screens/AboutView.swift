//
//  AboutView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let kinderAppURL = URL(string: "https://apps.apple.com/nl/app/kinder-find-baby-names/id1068421785")!
    private let whatsAppURL = URL(string: "https://wa.me/31611220008")!
    
    // Hidden analytics trigger
    @State private var versionTapCount = 0
    @State private var showAnalytics = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // MARK: - What is Petnames
                whatIsPetnamesSection
                
                // MARK: - What can you do
                featuresSection
                
                // MARK: - About the maker
                aboutMakerSection
                
                // MARK: - Contact
                contactSection
                
                // MARK: - Footer
                footerSection
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: 600) // Readable width
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Over Petnames")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            AnalyticsManager.shared.trackAboutViewed()
        }
    }
    
    // MARK: - What is Petnames
    
    private var whatIsPetnamesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Wat is Petnames?", systemImage: "sparkles")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Petnames helpt je samen de perfecte naam te vinden voor je huisdier.")
                .font(.body)
                .foregroundStyle(.primary)
            
            Text("Net als bij dating-apps swipe je door namen: naar rechts als je 'm leuk vindt, naar links als niet. Jullie likes worden vergeleken en zo ontstaat een shortlist met namen die jullie allebei leuk vinden!")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Features
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Wat kun je ermee?", systemImage: "list.bullet.rectangle")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 10) {
                FeatureRow(icon: "person.2.fill", color: .blue, text: "Samen swipen met je partner via een invite code")
                FeatureRow(icon: "slider.horizontal.3", color: .purple, text: "Filters op taal, categorie, lengte en beginletter")
                FeatureRow(icon: "wifi.slash", color: .green, text: "Werkt volledig offline – alle namen zitten in de app")
                FeatureRow(icon: "heart.fill", color: .pink, text: "Matches verschijnen als jullie beiden dezelfde naam liken")
            }
        }
    }
    
    // MARK: - About the Maker
    
    private var aboutMakerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Over de maker", systemImage: "person.fill")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Petnames is gemaakt door de maker van Kinder – de populaire babynamen app waarmee al duizenden ouders de perfecte naam voor hun kindje hebben gevonden.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                // Kinder app link
                Link(destination: kinderAppURL) {
                    HStack(spacing: 12) {
                        Image("kinderIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Kinder - Find Baby Names")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            
                            Text("Bekijk in de App Store")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    // MARK: - Contact
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Contact", systemImage: "envelope.fill")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Vragen, suggesties of feedback? Neem gerust contact op!")
                .font(.body)
                .foregroundStyle(.secondary)
            
            // WhatsApp button
            Link(destination: whatsAppURL) {
                HStack(spacing: 8) {
                    Image("whatsappIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    
                    Text("WhatsApp")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(hex: "25D366"))
                .clipShape(Capsule())
            }
        }
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.bottom, 8)
            
            Text("Petnames by Kinder")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            // Hidden analytics trigger - tap 5 times
            Text("Versie 1.0")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .onTapGesture {
                    versionTapCount += 1
                    if versionTapCount >= 5 {
                        versionTapCount = 0
                        showAnalytics = true
                    }
                }
            
            Text("© 2026 Krijn Haasnoot")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .sheet(isPresented: $showAnalytics) {
            InternalAnalyticsView()
        }
    }
}

// MARK: - Internal Analytics View (Hidden)

struct InternalAnalyticsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var appState = AppState.shared
    
    // Server stats
    @State private var serverStats: ServerAnalytics?
    @State private var topNames: [TopLikedName] = []
    @State private var isLoading = true
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab picker
                Picker("", selection: $selectedTab) {
                    Text("Lokaal").tag(0)
                    Text("Server").tag(1)
                    Text("Top 25").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                if selectedTab == 0 {
                    localStatsView
                } else if selectedTab == 1 {
                    serverStatsView
                } else {
                    topNamesView
                }
            }
            .navigationTitle("📈 Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sluiten") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadServerStats()
            }
        }
    }
    
    // MARK: - Local Stats View
    
    private var localStatsView: some View {
        List {
            Section("📊 Lokaal gebruik") {
                StatRow(label: "Namen geswiped", value: "\(NamesRepository.shared.swipedCount)")
                StatRow(label: "Resterende namen", value: "\(NamesRepository.shared.remainingCount)")
                StatRow(label: "Totaal beschikbaar", value: "\(NamesRepository.shared.totalNamesCount)")
                StatRow(label: "Lokale likes", value: "\(SwipesRepository.shared.localLikesCount)")
            }
            
            Section("🎛️ Actieve Filters") {
                StatRow(label: "Talen", value: appState.selectedLanguages.map { $0.flag }.joined())
                StatRow(label: "Stijlen", value: "\(appState.enabledStyles.count) / \(PetStyle.allCases.count)")
                StatRow(label: "Geslacht", value: appState.filters.gender == "any" ? "Alle" : appState.filters.gender)
            }
            
            Section("🏠 Household") {
                if let id = appState.householdId {
                    StatRow(label: "ID", value: String(id.uuidString.prefix(8)) + "...")
                }
                if let code = appState.inviteCode {
                    StatRow(label: "Code", value: code)
                }
            }
            
            Section("🗑️ Data beheer") {
                Button("Reset geswiped namen") {
                    NamesRepository.shared.clearSwipedNames()
                }
                .foregroundStyle(.orange)
                
                Button("Wis lokale likes") {
                    SwipesRepository.shared.clearLocalLikes()
                }
                .foregroundStyle(.orange)
                
                Button("Reset alle lokale data") {
                    Persistence.clearAll()
                    LocalNamesProvider.shared.clearCache()
                    NamesRepository.shared.clearSwipedNames()
                    SwipesRepository.shared.clearLocalLikes()
                }
                .foregroundStyle(.red)
            }
        }
    }
    
    // MARK: - Server Stats View
    
    private var serverStatsView: some View {
        List {
            if isLoading {
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            } else if let stats = serverStats {
                Section("👥 Gebruikers") {
                    StatRow(label: "Totaal gebruikers", value: "\(stats.totalUsers)")
                    StatRow(label: "Totaal households", value: "\(stats.totalHouseholds)")
                    StatRow(label: "Actief vandaag", value: "\(stats.activeToday)")
                    StatRow(label: "Actief deze week", value: "\(stats.activeWeek)")
                }
                
                Section("📊 Swipes") {
                    StatRow(label: "Totaal swipes", value: formatNumber(stats.totalSwipes))
                    StatRow(label: "Likes", value: formatNumber(stats.totalLikes))
                    StatRow(label: "Dismisses", value: formatNumber(stats.totalDismisses))
                    StatRow(label: "Like ratio", value: String(format: "%.1f%%", stats.likeRatio))
                }
                
                Section("💕 Matches") {
                    StatRow(label: "Totaal matches", value: formatNumber(stats.totalMatches))
                }
            } else {
                Section {
                    Text("Kon server stats niet laden")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button("Vernieuwen") {
                    Task { await loadServerStats() }
                }
            }
        }
    }
    
    // MARK: - Top Names View
    
    private var topNamesView: some View {
        List {
            if isLoading {
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            } else if topNames.isEmpty {
                Section {
                    Text("Geen data beschikbaar")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("🏆 Top 25 meest gelikte namen") {
                    ForEach(Array(topNames.enumerated()), id: \.element.name) { index, item in
                        HStack(spacing: 12) {
                            // Rank
                            Text("\(index + 1)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .frame(width: 28)
                            
                            // Medal for top 3
                            if index == 0 {
                                Text("🥇")
                            } else if index == 1 {
                                Text("🥈")
                            } else if index == 2 {
                                Text("🥉")
                            }
                            
                            // Gender indicator
                            Circle()
                                .fill(genderColor(item.gender))
                                .frame(width: 10, height: 10)
                            
                            // Name
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                if let setTitle = item.setTitle {
                                    Text(setTitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            // Like count
                            HStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.pink)
                                    .font(.caption)
                                Text("\(item.likesCount)")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func loadServerStats() async {
        isLoading = true
        defer { isLoading = false }
        
        let client = SupabaseClientProvider.shared.client
        
        // Load stats
        do {
            let response = try await client.rpc("get_analytics_stats").execute()
            serverStats = try JSONDecoder().decode(ServerAnalytics.self, from: response.data)
        } catch {
            print("❌ Failed to load server stats: \(error)")
        }
        
        // Load top names
        do {
            let response = try await client.rpc("get_top_liked_names", params: ["p_limit": 25]).execute()
            topNames = try JSONDecoder().decode([TopLikedName].self, from: response.data)
        } catch {
            print("❌ Failed to load top names: \(error)")
        }
    }
    
    private func formatNumber(_ num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
    
    private func genderColor(_ gender: String) -> Color {
        switch gender {
        case "male": return Color(hex: "4A90D9")
        case "female": return Color(hex: "E91E8C")
        default: return Color(hex: "2CB3B0")
        }
    }
}

// MARK: - Server Analytics Models

struct ServerAnalytics: Codable {
    let totalUsers: Int
    let totalHouseholds: Int
    let totalSwipes: Int
    let totalLikes: Int
    let totalDismisses: Int
    let totalMatches: Int
    let activeToday: Int
    let activeWeek: Int
    
    var likeRatio: Double {
        guard totalSwipes > 0 else { return 0 }
        return Double(totalLikes) / Double(totalSwipes) * 100
    }
    
    enum CodingKeys: String, CodingKey {
        case totalUsers = "total_users"
        case totalHouseholds = "total_households"
        case totalSwipes = "total_swipes"
        case totalLikes = "total_likes"
        case totalDismisses = "total_dismisses"
        case totalMatches = "total_matches"
        case activeToday = "active_today"
        case activeWeek = "active_week"
    }
}

struct TopLikedName: Codable {
    let name: String
    let gender: String
    let likesCount: Int
    let setTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case likesCount = "likes_count"
        case setTitle = "set_title"
    }
}

// MARK: - Stat Row

private struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
