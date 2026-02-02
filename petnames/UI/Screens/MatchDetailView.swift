//
//  MatchDetailView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct MatchDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var appState = AppState.shared
    
    let match: MatchRow
    
    @State private var likers: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    private var genderColor: Color {
        switch match.gender.lowercased() {
        case "female":
            return Color(hex: "FF2C55")
        case "male":
            return Color(hex: "1491F4")
        case "neutral":
            return Color(hex: "2CB3B0")
        default:
            return Color(hex: "38EF7D")
        }
    }
    
    private var gradientColors: [Color] {
        switch match.gender.lowercased() {
        case "female":
            return [Color(hex: "FF2C55"), Color(hex: "FF5C7A")]
        case "male":
            return [Color(hex: "1491F4"), Color(hex: "4DB3FF")]
        case "neutral":
            return [Color(hex: "2CB3B0"), Color(hex: "5DD4D1")]
        default:
            return [Color(hex: "11998E"), Color(hex: "38EF7D")]
        }
    }
    
    private var genderIcon: String {
        switch match.gender.lowercased() {
        case "male": return "♂"
        case "female": return "♀"
        case "neutral": return "⚥"
        default: return ""
        }
    }
    
    // Share text
    private var shareText: String {
        """
        🐾 Wij vinden "\(match.name)" een geweldige huisdiernaam!
        ❤️ \(match.likesCount) van ons vinden deze naam leuk!
        
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
            ScrollView {
                VStack(spacing: 32) {
                    // Name card
                    nameCard
                    
                    // Likers section
                    likersSection
                }
                .padding(24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Match Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
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
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await loadLikers()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: shareItems)
        }
    }
    
    // Generate a shareable image of the name card
    private func generateShareImage() {
        let shareView = ShareableNameCard(
            name: match.name,
            gender: match.gender,
            likesCount: match.likesCount,
            gradientColors: gradientColors,
            genderIcon: genderIcon
        )
        
        let renderer = ImageRenderer(content: shareView)
        renderer.scale = 3.0 // High resolution
        shareImage = renderer.uiImage
    }
    
    private var nameCard: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [genderColor, genderColor.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text(String(match.name.prefix(1)))
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(.white)
                )
            
            Text(match.name)
                .font(.system(size: 36, weight: .bold, design: .rounded))
            
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                
                Text("\(match.likesCount) people like this name")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    private var likersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Liked by")
                .font(.headline)
                .padding(.horizontal, 4)
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if likers.isEmpty {
                Text("No likers found")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(likers, id: \.self) { liker in
                        LikerRow(name: liker)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    private func loadLikers() async {
        guard let householdId = appState.householdId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            likers = try await MatchesRepository.shared.fetchLikers(
                householdId: householdId,
                nameId: match.nameId
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Liker Row

struct LikerRow: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "667eea").opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color(hex: "667eea"))
                )
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.caption)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Shareable Name Card (for image export)

struct ShareableNameCard: View {
    let name: String
    let gender: String
    let likesCount: Int
    let gradientColors: [Color]
    let genderIcon: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Main card
            ZStack {
                // Background gradient
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 16) {
                    // Gender icon
                    Text(genderIcon)
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                    
                    // Name
                    Text(name)
                        .font(.custom("Poppins-Bold", size: 52))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    // Likes badge
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                        Text("\(likesCount) likes")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.25))
                    )
                }
            }
            .frame(width: 350, height: 350)
            
            // Footer with branding
            HStack(spacing: 8) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(gradientColors[0])
                
                Text("Petnames by Kinder")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 16)
        }
        .padding(24)
        .background(Color.white)
    }
}

#Preview {
    MatchDetailView(match: MatchRow(
        nameId: UUID(),
        name: "Oliver",
        gender: "male",
        likesCount: 3
    ))
}

#Preview("Share Card") {
    ShareableNameCard(
        name: "Luna",
        gender: "female",
        likesCount: 3,
        gradientColors: [Color(hex: "FF2C55"), Color(hex: "FF5C7A")],
        genderIcon: "♀"
    )
}
