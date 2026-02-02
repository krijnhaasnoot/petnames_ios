//
//  HomeSwipeView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct HomeSwipeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var appState = AppState.shared
    @StateObject private var sessionManager = SessionManager.shared
    @ObservedObject private var petPhotoManager = PetPhotoManager.shared
    
    // Card stack - always try to have cards preloaded
    @State private var cardStack: [NameCard] = []
    @State private var isLoading = false
    @State private var isRefilling = false
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var isAnimatingSwipe = false
    @State private var lastSwipe: (nameId: UUID, card: NameCard, decision: SwipeDecision)?
    @State private var showFilters = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var isEmpty = false
    @State private var showMatchAlert = false
    @State private var matchedName: String = ""
    @State private var matchedGender: String = ""
    @State private var navigateToMatches = false
    
    private let bufferSize = 10
    private let visibleCards = 3 // Number of cards visible in stack
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background - adaptive for dark mode
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar
                    topBar
                    
                    Spacer()
                    
                    // Card stack area
                    cardStackArea
                    
                    Spacer()
                    
                    // Bottom buttons
                    bottomButtons
                        .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await loadInitialData()
        }
        .sheet(isPresented: $showFilters) {
            FiltersSheetView {
                Task { await reloadWithNewFilters() }
            }
        }
        .alert(String(localized: "error.title"), isPresented: $showError) {
            Button(String(localized: "error.ok")) { showError = false }
        } message: {
            Text(errorMessage ?? "")
        }
        .overlay {
            if showMatchAlert {
                MatchPopupView(
                    name: matchedName,
                    gender: matchedGender,
                    onViewMatches: {
                        showMatchAlert = false
                        // Navigate to matches after popup closes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToMatches = true
                        }
                    },
                    onContinue: {
                        showMatchAlert = false
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(100)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showMatchAlert)
        .navigationDestination(isPresented: $navigateToMatches) {
            MatchesView()
        }
    }
    
    // MARK: - Top Bar
    
    private var topBar: some View {
        HStack(spacing: 0) {
            // Profile
            NavigationLink {
                ProfileView()
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "4A4A4A"))
            }
            .frame(maxWidth: .infinity)
            
            // Likes
            NavigationLink {
                LikesView()
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "4A4A4A"))
            }
            .frame(maxWidth: .infinity)
            
            // Filter button
            Button {
                showFilters = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "4A4A4A"))
            }
            .frame(maxWidth: .infinity)
            
            // Matches
            NavigationLink {
                MatchesView()
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Card Stack Area
    
    @ViewBuilder
    private var cardStackArea: some View {
        if isLoading && cardStack.isEmpty {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("home.loadingNames")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 320, height: 320)
        } else if isEmpty || cardStack.isEmpty {
            emptyStateView
        } else {
            ZStack {
                // Show cards in reverse order (back to front)
                ForEach(Array(cardStack.prefix(visibleCards).enumerated().reversed()), id: \.element.id) { index, card in
                    let isTopCard = index == 0
                    
                    NameCardView(
                        name: card.name,
                        setTitle: card.setTitle,
                        gender: card.gender,
                        offset: isTopCard ? offset : .zero,
                        rotation: isTopCard ? rotation : 0,
                        petImage: petPhotoManager.petImage,
                        namePosition: petPhotoManager.namePosition
                    )
                    .scaleEffect(scaleForIndex(index))
                    .offset(y: offsetForIndex(index))
                    .zIndex(Double(visibleCards - index))
                    .allowsHitTesting(isTopCard && !isAnimatingSwipe)
                    .gesture(isTopCard ? dragGesture : nil)
                    // Quick animation for stack movement - doesn't block interaction
                    .animation(.easeOut(duration: 0.15), value: cardStack.count)
                }
            }
        }
    }
    
    // Stack visual effects - no transparency, just scale and offset
    private func scaleForIndex(_ index: Int) -> CGFloat {
        let baseScale: CGFloat = 1.0
        let scaleDecrement: CGFloat = 0.04
        return baseScale - (CGFloat(index) * scaleDecrement)
    }
    
    private func offsetForIndex(_ index: Int) -> CGFloat {
        let offsetIncrement: CGFloat = 18
        return CGFloat(index) * offsetIncrement
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("home.noMoreNames")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("home.noMoreNamesDescription")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showFilters = true
            } label: {
                Label("home.adjustFilters", systemImage: "slider.horizontal.3")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "667eea"))
        }
        .frame(width: 320, height: 320)
    }
    
    // MARK: - Bottom Buttons
    
    private var bottomButtons: some View {
        HStack(spacing: 32) {
            RoundActionButton(type: .dislike, disabled: cardStack.isEmpty || isAnimatingSwipe) {
                animateOffScreen(direction: .left) {
                    dismissCard()
                }
            }
            
            RoundActionButton(type: .undo, disabled: lastSwipe == nil || isAnimatingSwipe) {
                undoSwipe()
            }
            
            RoundActionButton(type: .like, disabled: cardStack.isEmpty || isAnimatingSwipe) {
                animateOffScreen(direction: .right) {
                    likeCard()
                }
            }
        }
    }
    
    // MARK: - Drag Gesture
    
    @State private var isDragging = false
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged { value in
                guard !isAnimatingSwipe else { return }
                isDragging = true
                offset = value.translation
                rotation = Double(value.translation.width) * AppConfig.cardRotationMultiplier
            }
            .onEnded { value in
                guard !isAnimatingSwipe else { return }
                isDragging = false
                
                let threshold = AppConfig.swipeThreshold
                
                if value.translation.width > threshold {
                    // Swipe right - Like
                    animateOffScreen(direction: .right) {
                        likeCard()
                    }
                } else if value.translation.width < -threshold {
                    // Swipe left - Dismiss
                    animateOffScreen(direction: .left) {
                        dismissCard()
                    }
                } else {
                    // Return to center - quick spring animation
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = .zero
                        rotation = 0
                    }
                }
            }
    }
    
    private enum SwipeDirection {
        case left, right
    }
    
    private func animateOffScreen(direction: SwipeDirection, completion: @escaping () -> Void) {
        guard !isAnimatingSwipe else { return }
        
        isAnimatingSwipe = true
        isDragging = false
        
        let screenWidth = UIScreen.main.bounds.width
        let targetX: CGFloat = direction == .right ? screenWidth * 1.5 : -screenWidth * 1.5
        
        // Start the fly-off animation
        withAnimation(.easeOut(duration: 0.15)) {
            offset = CGSize(width: targetX, height: 0)
            rotation = direction == .right ? 20 : -20
        }
        
        // Remove card and allow next swipe quickly (don't wait for full animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
    
    // MARK: - Actions
    
    private func loadInitialData() async {
        // Load name sets if needed
        if appState.nameSets.isEmpty {
            do {
                let sets = try await NamesRepository.shared.fetchNameSets()
                appState.updateNameSets(sets)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        // Fill the card stack
        await fillCardStack()
    }
    
    private func reloadWithNewFilters() async {
        // Clear current stack when filters change
        cardStack.removeAll()
        isEmpty = false
        offset = .zero
        rotation = 0
        
        // Refill with new filters
        await fillCardStack()
    }
    
    private func fillCardStack() async {
        guard let householdId = appState.householdId else { return }
        guard !isRefilling else { return }
        
        isRefilling = true
        isLoading = cardStack.isEmpty
        defer { 
            isRefilling = false 
            isLoading = false
        }
        
        // Calculate how many cards we need
        let needed = bufferSize - cardStack.count
        
        guard needed > 0 else { return }
        
        do {
            let enabledIds = appState.enabledSetIds.isEmpty ? appState.nameSets.map { $0.id } : appState.enabledSetIds
            
            // Exclude cards already in stack (by name, to prevent duplicates)
            let excludeNames = cardStack.map { $0.name }
            
            let newCards = try await NamesRepository.shared.getNextNames(
                householdId: householdId,
                enabledSetIds: enabledIds,
                gender: appState.filters.gender,
                startsWith: appState.filters.startsWith,
                maxLength: appState.filters.maxLength,
                limit: needed,
                excludeNames: excludeNames
            )
            
            // Extra safety: filter out any cards with names already in stack
            let existingNames = Set(cardStack.map { $0.name.lowercased() })
            var uniqueNewCards: [NameCard] = []
            var seenInBatch = Set<String>()
            
            for card in newCards {
                let nameLower = card.name.lowercased()
                // Skip if already in stack, or duplicate within this batch
                if existingNames.contains(nameLower) || seenInBatch.contains(nameLower) {
                    print("⚠️ Filtered out duplicate: \(card.name)")
                    continue
                }
                seenInBatch.insert(nameLower)
                uniqueNewCards.append(card)
            }
            
            cardStack.append(contentsOf: uniqueNewCards)
            print("📥 Added \(uniqueNewCards.count) cards, stack now: \(cardStack.count)")
            
            // Check if empty
            if cardStack.isEmpty {
                isEmpty = true
            }
        } catch {
            // Only show error if we have no cards at all
            if cardStack.isEmpty {
                errorMessage = error.localizedDescription
                showError = true
                isEmpty = true
            }
        }
    }
    
    private func removeTopCard() {
        guard !cardStack.isEmpty else { return }
        
        // Remove top card
        cardStack.removeFirst()
        
        // Reset position for next card
        offset = .zero
        rotation = 0
        isAnimatingSwipe = false
        
        // Check if empty
        if cardStack.isEmpty {
            isEmpty = true
        }
        
        // Refill stack in background if running low
        if cardStack.count < bufferSize / 2 {
            Task {
                await fillCardStack()
            }
        }
    }
    
    private func likeCard() {
        guard let card = cardStack.first,
              let householdId = appState.householdId,
              let userId = sessionManager.currentUserId else { return }
        
        lastSwipe = (card.id, card, .like)
        
        // Mark as swiped locally (for offline tracking)
        NamesRepository.shared.markNameAsSwiped(card.name)
        
        // Save like locally first (instant feedback)
        SwipesRepository.shared.addLocalLike(
            name: card.name,
            gender: card.gender,
            setTitle: card.setTitle
        )
        
        // Remove top card (triggers stack animation)
        removeTopCard()
        
        // Sync to Supabase in background (for both local and server names)
        Task {
            do {
                let isMatch: Bool
                
                if card.isLocal {
                    // Look up the name in the database and sync
                    isMatch = try await SwipesRepository.shared.insertSwipeByName(
                        householdId: householdId,
                        userId: userId,
                        name: card.name,
                        gender: card.gender,
                        decision: .like
                    )
                } else {
                    // Use the existing ID
                    try await SwipesRepository.shared.insertSwipe(
                        householdId: householdId,
                        userId: userId,
                        nameId: card.id,
                        decision: .like
                    )
                    // Check for match separately
                    isMatch = try await SwipesRepository.shared.checkForMatchByName(
                        householdId: householdId,
                        name: card.name,
                        userId: userId
                    )
                }
                
                // Show match notification if we found a match!
                if isMatch {
                    await MainActor.run {
                        matchedName = card.name
                        matchedGender = card.gender
                        showMatchAlert = true
                        // No local notification needed - the in-app popup handles this
                    }
                    
                    // Send push to other household members
                    await NotificationManager.shared.sendMatchPushToHousehold(
                        householdId: householdId,
                        name: card.name
                    )
                }
            } catch {
                print("⚠️ Failed to sync like to server: \(error.localizedDescription)")
                // Like is already saved locally, so user experience is not affected
            }
        }
    }
    
    private func dismissCard() {
        guard let card = cardStack.first,
              let householdId = appState.householdId,
              let userId = sessionManager.currentUserId else { return }
        
        lastSwipe = (card.id, card, .dismiss)
        
        // Mark as swiped locally (for offline tracking)
        NamesRepository.shared.markNameAsSwiped(card.name)
        
        // Remove top card (triggers stack animation)
        removeTopCard()
        
        // Only sync to Supabase if this is a server-sourced name (has real ID)
        if !card.isLocal {
            Task {
                do {
                    try await SwipesRepository.shared.insertSwipe(
                        householdId: householdId,
                        userId: userId,
                        nameId: card.id,
                        decision: .dismiss
                    )
                } catch {
                    // Silently ignore - swipe is tracked locally
                    print("⚠️ Failed to sync dismiss to server: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func undoSwipe() {
        guard let swipe = lastSwipe,
              let householdId = appState.householdId,
              let userId = sessionManager.currentUserId else { return }
        
        // Undo the local swipe tracking
        NamesRepository.shared.undoSwipe(swipe.card.name)
        
        // Remove from local likes if it was a like
        if swipe.decision == .like {
            SwipesRepository.shared.removeLocalLike(name: swipe.card.name)
        }
        
        // Restore the card to the top of the stack
        cardStack.insert(swipe.card, at: 0)
        lastSwipe = nil
        isEmpty = false
        
        // Reset position
        offset = .zero
        rotation = 0
        
        // Only sync to Supabase if this was a server-sourced name
        if !swipe.card.isLocal {
            Task {
                do {
                    try await SwipesRepository.shared.deleteSwipe(
                        householdId: householdId,
                        userId: userId,
                        nameId: swipe.nameId
                    )
                } catch {
                    // Silently ignore - undo is tracked locally
                    print("⚠️ Failed to sync undo to server: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    HomeSwipeView()
}
