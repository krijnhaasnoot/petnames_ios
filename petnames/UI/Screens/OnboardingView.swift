//
//  OnboardingView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var appState = AppState.shared
    
    @State private var displayName = ""
    @State private var inviteCodeInput = ""
    @State private var createdInviteCode: String?
    @State private var isCreating = false
    @State private var isJoining = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showShareSheet = false
    
    private var isLoading: Bool {
        isCreating || isJoining
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background - adaptive for dark mode
            Group {
                if colorScheme == .dark {
                    Color(UIColor.systemBackground)
                } else {
                    LinearGradient(
                        colors: [Color(hex: "f5f7fa"), Color(hex: "c3cfe2")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Display name (shared for both options)
                    displayNameSection
                    
                    // Create section
                    createSection
                    
                    // Divider
                    dividerSection
                    
                    // Join section
                    joinSection
                }
                .padding(24)
                .frame(maxWidth: 500) // Limit width on iPad
                .frame(maxWidth: .infinity) // Center on screen
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .disabled(isLoading)
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .sheet(isPresented: $showShareSheet) {
            if let code = createdInviteCode {
                ShareSheet(items: ["🐾 Join mijn Petnames household!\n\nCode: \(code)\n\nDownload de app:\nhttps://apps.apple.com/app/petnames-by-kinder/id6504684930"])
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Petnames")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text("Find the perfect name together")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }
    
    // MARK: - Display Name Section
    
    private var displayNameSection: some View {
        VStack(spacing: 12) {
            Text("Hoe mag je partner je noemen?")
                .font(.headline)
            
            TextField("Je naam (optioneel)", text: $displayName)
                .textFieldStyle(.roundedBorder)
                .textContentType(.name)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            
            Text("Dit ziet je partner als jullie samen swipen")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Create Section
    
    private var createSection: some View {
        VStack(spacing: 16) {
            Text("Nieuw household starten")
                .font(.headline)
            
            Text("Maak een household aan en deel de code met je partner")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                Task { await createHousehold() }
            } label: {
                HStack {
                    if isCreating {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "plus.circle.fill")
                    }
                    Text("Maak household")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isLoading)
            
            // Show invite code after creation
            if let code = createdInviteCode {
                inviteCodeDisplay(code: code)
            }
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Invite Code Display
    
    private func inviteCodeDisplay(code: String) -> some View {
        VStack(spacing: 12) {
            Text("Share this code")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(code)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
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
            
            Button("Continue to App") {
                // Navigation happens automatically via appState change
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "667eea"))
            .padding(.top, 8)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Divider
    
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(.secondary.opacity(0.3))
                .frame(height: 1)
            
            Text("OR")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
            
            Rectangle()
                .fill(.secondary.opacity(0.3))
                .frame(height: 1)
        }
    }
    
    // MARK: - Join Section
    
    private var joinSection: some View {
        VStack(spacing: 16) {
            Text("Bestaand household joinen")
                .font(.headline)
            
            TextField("Voer invite code in", text: $inviteCodeInput)
                .textFieldStyle(.roundedBorder)
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.characters)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            
            Button {
                Task { await joinHousehold() }
            } label: {
                HStack {
                    if isJoining {
                        ProgressView()
                            .tint(Color(hex: "667eea"))
                    } else {
                        Image(systemName: "person.2.fill")
                    }
                    Text("Join household")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "667eea"), lineWidth: 2)
                )
                .foregroundStyle(Color(hex: "667eea"))
                .fontWeight(.semibold)
            }
            .disabled(isLoading || inviteCodeInput.isEmpty)
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Actions
    
    private func createHousehold() async {
        isCreating = true
        defer { isCreating = false }
        
        do {
            let (householdId, inviteCode) = try await HouseholdRepository.shared.createHousehold(
                displayName: displayName.isEmpty ? nil : displayName
            )
            
            createdInviteCode = inviteCode
            appState.setHousehold(id: householdId, inviteCode: inviteCode)
            
            // Track analytics
            AnalyticsManager.shared.trackHouseholdCreated()
            AnalyticsManager.shared.trackOnboardingCompleted(method: "create")
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func joinHousehold() async {
        isJoining = true
        defer { isJoining = false }
        
        do {
            let householdId = try await HouseholdRepository.shared.joinHousehold(
                inviteCode: inviteCodeInput.trimmingCharacters(in: .whitespaces)
            )
            
            appState.setHousehold(id: householdId)
            
            // Update display name if provided
            if !displayName.isEmpty, let userId = SessionManager.shared.currentUserId {
                try? await HouseholdRepository.shared.updateDisplayName(
                    userId: userId,
                    displayName: displayName
                )
            }
            
            // Track analytics
            AnalyticsManager.shared.trackHouseholdJoined()
            AnalyticsManager.shared.trackOnboardingCompleted(method: "join")
            
            // Notify other household members that someone joined
            let memberName = displayName.isEmpty ? "Iemand" : displayName
            await NotificationManager.shared.sendNewMemberPushToHousehold(
                householdId: householdId,
                memberName: memberName
            )
        } catch {
            errorMessage = "Invite code niet gevonden. Controleer en probeer opnieuw."
            showError = true
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    OnboardingView()
}
