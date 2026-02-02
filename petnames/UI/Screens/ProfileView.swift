//
//  ProfileView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var appState = AppState.shared
    @StateObject private var sessionManager = SessionManager.shared
    
    @State private var inviteCode: String?
    @State private var counts: SwipeCounts?
    @State private var members: [HouseholdMember] = []
    @State private var isLoading = false
    @State private var isLoadingMembers = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showResetConfirmation = false
    @State private var showShareSheet = false
    @State private var showEditName = false
    @State private var editingName = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Pet photo section
                    petPhotoSection
                    
                    // Invite code section
                    inviteCodeSection
                    
                    // Household members section
                    householdMembersSection
                    
                    // Stats section
                    statsSection
                    
                    // Actions section
                    actionsSection
                }
                .padding(24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Profile")
            .refreshable {
                await loadProfileData()
            }
        }
        .task {
            await loadProfileData()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .alert("Reset Household?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetHousehold()
            }
        } message: {
            Text("This will remove you from the current household locally. You'll need to create or join a new household.")
        }
        .sheet(isPresented: $showShareSheet) {
            if let code = inviteCode {
                ShareSheet(items: ["🐾 Join mijn Petnames household!\n\nCode: \(code)\n\nDownload de app:\nhttps://apps.apple.com/app/petnames-by-kinder/id6504684930"])
            }
        }
        .alert("Naam wijzigen", isPresented: $showEditName) {
            TextField("Je naam", text: $editingName)
            Button("Annuleren", role: .cancel) {}
            Button("Opslaan") {
                Task {
                    await saveDisplayName()
                }
            }
        } message: {
            Text("Voer je nieuwe naam in")
        }
    }
    
    // MARK: - Pet Photo Section
    
    private var petPhotoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "pawprint.fill")
                    .foregroundStyle(Color(hex: "667eea"))
                Text("Huisdier Foto")
                    .font(.headline)
                Spacer()
            }
            
            Text("Voeg een foto van je huisdier toe. Deze verschijnt op de achtergrond van alle naamkaartjes.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            
            PetPhotoPicker()
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    // MARK: - Invite Code Section
    
    private var inviteCodeSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "667eea"))
            
            Text("Your Household")
                .font(.headline)
            
            if isLoading && inviteCode == nil {
                ProgressView()
            } else if let code = inviteCode {
                Text(code)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(hex: "667eea"))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "667eea").opacity(0.1))
                    )
                
                HStack(spacing: 16) {
                    Button {
                        UIPasteboard.general.string = code
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        showShareSheet = true
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Text("No invite code available")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    // MARK: - Household Members Section
    
    private var householdMembersSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundStyle(Color(hex: "667eea"))
                Text("Household Members")
                    .font(.headline)
                Spacer()
                
                // Member count badge
                Text("\(members.count)")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(hex: "667eea")))
            }
            
            if isLoadingMembers && members.isEmpty {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading members...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else if members.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("No members found")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(members) { member in
                        MemberRow(
                            member: member,
                            isCurrentUser: member.id == sessionManager.currentUserId,
                            onEditName: member.id == sessionManager.currentUserId ? {
                                startEditingName(currentName: member.displayName ?? "")
                            } : nil
                        )
                    }
                }
            }
            
            // Connection status
            if members.count == 1 {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.orange)
                    Text("You're the only one here! Share the invite code to connect with others.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            } else if members.count > 1 {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Connected with \(members.count - 1) other\(members.count - 1 == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Color(hex: "667eea"))
                Text("Your Stats")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 24) {
                StatBox(
                    title: "Liked",
                    value: counts?.likes ?? 0,
                    icon: "heart.fill",
                    color: .pink
                )
                
                StatBox(
                    title: "Dismissed",
                    value: counts?.dismisses ?? 0,
                    icon: "hand.thumbsdown.fill",
                    color: .orange
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            // About link
            NavigationLink {
                AboutView()
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("Over Petnames")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.tertiarySystemGroupedBackground))
                )
                .foregroundStyle(.primary)
            }
            
            // Reset button
            Button {
                showResetConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset Household Locally")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 1)
                )
                .foregroundStyle(.red)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 15, x: 0, y: 5)
    }
    
    // MARK: - Actions
    
    private func loadProfileData() async {
        guard let householdId = appState.householdId else { return }
        
        isLoading = true
        isLoadingMembers = true
        defer { 
            isLoading = false 
            isLoadingMembers = false
        }
        
        // Load invite code
        if let cached = appState.inviteCode {
            inviteCode = cached
        } else {
            do {
                let code = try await HouseholdRepository.shared.fetchInviteCode(householdId: householdId)
                inviteCode = code
                appState.inviteCode = code
            } catch {
                // Non-critical error, just log
                print("Failed to fetch invite code: \(error)")
            }
        }
        
        // Load household members
        do {
            members = try await HouseholdRepository.shared.fetchHouseholdMembers(householdId: householdId)
        } catch {
            // Non-critical error
            print("Failed to fetch household members: \(error)")
        }
        
        // Load counts
        if let userId = sessionManager.currentUserId {
            do {
                counts = try await SwipesRepository.shared.fetchCounts(
                    householdId: householdId,
                    userId: userId
                )
            } catch {
                // Non-critical error
                print("Failed to fetch counts: \(error)")
            }
        }
    }
    
    private func resetHousehold() {
        appState.resetHousehold()
    }
    
    private func saveDisplayName() async {
        guard let userId = sessionManager.currentUserId else { return }
        guard !editingName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        do {
            try await HouseholdRepository.shared.updateDisplayName(
                userId: userId,
                displayName: editingName.trimmingCharacters(in: .whitespaces)
            )
            // Reload members to show updated name
            await loadProfileData()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func startEditingName(currentName: String) {
        editingName = currentName
        showEditName = true
    }
}

// MARK: - Member Row

struct MemberRow: View {
    let member: HouseholdMember
    let isCurrentUser: Bool
    var onEditName: (() -> Void)?
    
    private var joinedText: String {
        guard let date = member.createdAt else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(isCurrentUser ? Color(hex: "667eea") : Color(hex: "667eea").opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Text(member.displayLabel.prefix(1).uppercased())
                    .font(.headline)
                    .foregroundStyle(isCurrentUser ? .white : Color(hex: "667eea"))
            }
            
            // Name and status
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(member.displayLabel)
                        .font(.body)
                        .fontWeight(isCurrentUser ? .semibold : .regular)
                    
                    if isCurrentUser {
                        Text("(Jij)")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "667eea"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color(hex: "667eea").opacity(0.15))
                            )
                    }
                }
                
                if !joinedText.isEmpty {
                    Text("Joined \(joinedText)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Edit button for current user
            if isCurrentUser, let onEdit = onEditName {
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "667eea"))
                }
            }
            
            // Online indicator (always show as connected for now)
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentUser ? Color(hex: "667eea").opacity(0.08) : Color(UIColor.tertiarySystemGroupedBackground))
        )
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text("\(value)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ProfileView()
}
