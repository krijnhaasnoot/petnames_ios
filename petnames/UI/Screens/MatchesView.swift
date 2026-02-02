//
//  MatchesView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct MatchesView: View {
    @StateObject private var appState = AppState.shared
    
    @State private var matches: [MatchRow] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var selectedMatch: MatchRow?
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    // Share text
    private var shareText: String {
        guard !matches.isEmpty else { return "" }
        let namesList = matches.prefix(10).map { "❤️ \($0.name)" }.joined(separator: "\n")
        let extra = matches.count > 10 ? "\n...en \(matches.count - 10) meer!" : ""
        return """
        🐾 Onze favoriete huisdiernamen!
        
        \(namesList)\(extra)
        
        Download Petnames by Kinder:
        https://apps.apple.com/app/petnames-by-kinder/id6504684930
        """
    }
    
    // Share items including image and text
    private var shareItems: [Any] {
        var items: [Any] = []
        if let image = shareImage {
            items.append(image)
        }
        items.append(shareText)
        return items
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading && matches.isEmpty {
                    ProgressView("Loading matches...")
                } else if matches.isEmpty {
                    emptyStateView
                } else {
                    matchesList
                }
            }
            .navigationTitle("Matches")
            .toolbar {
                if !matches.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            // Track share
                            AnalyticsManager.shared.trackMatchShared(shareType: "list")
                            
                            // Generate image first, then show sheet
                            generateShareImage()
                            // Small delay to ensure image is ready
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showShareSheet = true
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .refreshable {
                await loadMatches()
            }
        }
        .task {
            await loadMatches()
            // Track screen view
            AnalyticsManager.shared.trackMatchesListViewed(count: matches.count)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .sheet(item: $selectedMatch) { match in
            MatchDetailView(match: match)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: shareItems)
        }
    }
    
    // Generate a shareable image of the matches list
    private func generateShareImage() {
        let shareView = ShareableMatchesList(matches: matches)
        let renderer = ImageRenderer(content: shareView)
        renderer.scale = 3.0 // High resolution
        shareImage = renderer.uiImage
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No matches yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("When two or more people in your\nhousehold like the same name,\nit will appear here!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var matchesList: some View {
        List {
            ForEach(matches) { match in
                MatchRowView(match: match)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedMatch = match
                    }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func loadMatches() async {
        guard let householdId = appState.householdId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            matches = try await MatchesRepository.shared.fetchMatches(householdId: householdId)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Match Row View

struct MatchRowView: View {
    let match: MatchRow
    
    private var genderColor: Color {
        switch match.gender.lowercased() {
        case "female":
            return Color(hex: "FF2C55")
        case "male":
            return Color(hex: "1491F4")
        case "neutral":
            return Color(hex: "07D6CC")
        default:
            return Color(hex: "38EF7D")
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [genderColor, genderColor.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(match.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(match.name)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.pink)
                    
                    Text("\(match.likesCount) likes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Likes badge
            Text("\(match.likesCount)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.pink)
                )
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Shareable Matches List (for image export)

struct ShareableMatchesList: View {
    let matches: [MatchRow]
    
    private func genderColor(for gender: String) -> Color {
        switch gender.lowercased() {
        case "female": return Color(hex: "FF2C55")
        case "male": return Color(hex: "1491F4")
        case "neutral": return Color(hex: "2CB3B0")
        default: return Color(hex: "38EF7D")
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                    
                    Text("Onze Matches")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundStyle(.white)
                    
                    Text("\(matches.count) namen die we allemaal leuk vinden!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.vertical, 24)
            }
            .frame(height: 140)
            
            // Names list
            VStack(spacing: 12) {
                ForEach(matches.prefix(8)) { match in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [genderColor(for: match.gender), genderColor(for: match.gender).opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(String(match.name.prefix(1)))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            )
                        
                        Text(match.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundStyle(.pink)
                            Text("\(match.likesCount)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.pink)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                if matches.count > 8 {
                    Text("+ \(matches.count - 8) meer...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
            .padding(20)
            
            // Footer with branding
            HStack(spacing: 8) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "667eea"))
                
                Text("Petnames by Kinder")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 20)
        }
        .frame(width: 350)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    MatchesView()
}

#Preview("Share List") {
    ShareableMatchesList(matches: [
        MatchRow(nameId: UUID(), name: "Luna", gender: "female", likesCount: 3),
        MatchRow(nameId: UUID(), name: "Max", gender: "male", likesCount: 2),
        MatchRow(nameId: UUID(), name: "Charlie", gender: "neutral", likesCount: 2)
    ])
    .padding()
    .background(Color.gray.opacity(0.2))
}
