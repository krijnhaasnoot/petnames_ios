//
//  LikesView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct LikesView: View {
    @StateObject private var appState = AppState.shared
    @StateObject private var sessionManager = SessionManager.shared
    
    @State private var likes: [LikedNameRow] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading && likes.isEmpty {
                    ProgressView("Loading likes...")
                } else if likes.isEmpty {
                    emptyStateView
                } else {
                    likesList
                }
            }
            .navigationTitle("Your Likes")
            .refreshable {
                await loadLikes()
            }
        }
        .task {
            await loadLikes()
            // Track screen view
            AnalyticsManager.shared.trackLikesViewed(count: likes.count)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No likes yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start swiping to like names\nyou love!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var likesList: some View {
        List {
            ForEach(likes) { like in
                LikeRow(like: like)
            }
            .onDelete(perform: removeLikes)
        }
        .listStyle(.insetGrouped)
    }
    
    private func loadLikes() async {
        guard let householdId = appState.householdId,
              let userId = sessionManager.currentUserId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            likes = try await SwipesRepository.shared.fetchLikes(
                householdId: householdId,
                userId: userId
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func removeLikes(at offsets: IndexSet) {
        guard let householdId = appState.householdId,
              let userId = sessionManager.currentUserId else { return }
        
        let likesToRemove = offsets.map { likes[$0] }
        
        // Optimistic update
        likes.remove(atOffsets: offsets)
        
        Task {
            for like in likesToRemove {
                do {
                    try await SwipesRepository.shared.deleteSwipe(
                        householdId: householdId,
                        userId: userId,
                        nameId: like.nameId
                    )
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                    // Reload to restore state
                    await loadLikes()
                    break
                }
            }
        }
    }
}

// MARK: - Like Row

struct LikeRow: View {
    let like: LikedNameRow
    
    private var genderColor: Color {
        switch like.gender.lowercased() {
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
                .fill(genderColor.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(like.name.prefix(1)))
                        .font(.headline)
                        .foregroundStyle(genderColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(like.name)
                    .font(.headline)
                
                Text(like.setTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundStyle(.pink)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LikesView()
}
