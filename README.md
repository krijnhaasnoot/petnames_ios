# 🐾 Petnames by Kinder

A native iOS app for choosing the perfect name for your pet — together with your household!

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-orange)
![Supabase](https://img.shields.io/badge/Backend-Supabase-green)

## ✨ Features

### 🎴 Swipe to Choose
- Tinder-style card swiping for pet names
- Smooth animations with gesture feedback
- Visual indicators (green for like, red for dismiss)
- Undo your last swipe

### 👨‍👩‍👧‍👦 Household Matching
- Create or join a household with invite codes
- See when multiple people like the same name
- Get notified when there's a match!

### 🌍 Multi-Language Support
10 languages with 7 style categories each:
- 🇳🇱 Dutch (NL)
- 🇬🇧 English (EN)
- 🇩🇪 German (DE)
- 🇫🇷 French (FR)
- 🇪🇸 Spanish (ES)
- 🇮🇹 Italian (IT)
- 🇸🇪 Swedish (SV)
- 🇳🇴 Norwegian (NO)
- 🇩🇰 Danish (DA)
- 🇫🇮 Finnish (FI)

### 🏷️ Name Categories
- 💕 Cute & Sweet
- 💪 Short & Strong
- 👑 Classic
- 😄 Funny & Playful
- 🕰️ Vintage
- 🌿 Nature Inspired
- 🐾 Pet Nicknames

### 📱 Additional Features
- **Offline-first**: 1750+ names bundled in the app
- **Pet photo**: Upload your pet's photo as card background
- **Smart positioning**: AI analyzes photo to position name text
- **Push notifications**: Get notified about matches
- **Share matches**: Share your matched names with friends
- **Localized UI**: App interface in all 10 languages

## 🛠️ Tech Stack

- **Frontend**: SwiftUI (iOS 17+)
- **Backend**: [Supabase](https://supabase.com)
  - PostgreSQL database
  - Anonymous authentication
  - Edge Functions (Deno)
  - Row Level Security (RLS)
- **Push Notifications**: APNs via Supabase Edge Functions
- **Image Analysis**: Vision framework for saliency detection

## 📁 Project Structure

```
petnames/
├── Core/
│   ├── AppConfig.swift          # Configuration & constants
│   ├── AppState.swift           # Global app state
│   ├── LocalNamesProvider.swift # Offline names management
│   ├── Models.swift             # Data models
│   ├── NameSetClassifier.swift  # Language/style classification
│   ├── NotificationManager.swift # Push notifications
│   ├── Persistence.swift        # UserDefaults storage
│   ├── PetPhotoManager.swift    # Photo upload & analysis
│   └── SessionManager.swift     # Auth session management
├── Data/
│   ├── HouseholdRepository.swift
│   ├── MatchesRepository.swift
│   ├── NamesRepository.swift
│   └── SwipesRepository.swift
├── UI/
│   ├── Components/
│   │   ├── MatchPopupView.swift
│   │   ├── NameCardView.swift
│   │   ├── RoundActionButton.swift
│   │   └── TopIconBar.swift
│   └── Screens/
│       ├── AboutView.swift
│       ├── FiltersSheetView.swift
│       ├── HomeSwipeView.swift
│       ├── LikesView.swift
│       ├── MatchDetailView.swift
│       ├── MatchesView.swift
│       ├── NotificationPermissionView.swift
│       ├── OnboardingView.swift
│       ├── ProfileView.swift
│       └── RootView.swift
└── Resources/
    └── bundled_names.json       # 1750+ offline names
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15+
- iOS 17+ device or simulator
- Supabase account

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/krijnhaasnoot/petnames_ios.git
   cd petnames_ios
   ```

2. **Configure Supabase**
   - Create a new Supabase project
   - Run the migrations in `migrations/` folder
   - Update `AppConfig.swift` with your Supabase URL and anon key

3. **Run SQL Migrations**
   ```sql
   -- Run in order:
   -- 1. supabase_migrations.sql (base schema)
   -- 2. migrations/001_add_language_style_columns.sql
   -- 3. migrations/002_seed_all_languages.sql
   -- 4. migrations/003_push_notifications.sql
   -- 5. migrations/004_gemini_names_seed.sql
   ```

4. **Deploy Edge Function** (for push notifications)
   ```bash
   supabase functions deploy send-push
   ```

5. **Open in Xcode**
   ```bash
   open petnames.xcodeproj
   ```

6. **Build and Run** 🎉

## 🔐 Supabase Configuration

### Required Tables
- `households` - Household groups with invite codes
- `profiles` - User profiles with push tokens
- `name_sets` - Name categories by language/style
- `names` - Individual pet names
- `swipes` - User swipe decisions
- `household_matches` (view) - Names liked by 2+ household members

### RPC Functions
- `create_household(display_name)` - Create new household
- `join_household(invite_code)` - Join existing household
- `get_next_names(...)` - Get names for swiping
- `check_for_match(...)` - Check if a like creates a match

## 📲 Push Notifications Setup

1. Create an APNs key in Apple Developer Portal
2. Add environment variables to Supabase:
   - `APNS_KEY_ID`
   - `APNS_TEAM_ID`
   - `APNS_PRIVATE_KEY`
   - `BUNDLE_ID`

## 🎨 Design

The app features:
- Custom Poppins font family
- Gender-based color coding:
  - 💙 Male: `#4A90D9`
  - 💗 Female: `#E91E8C`
  - 💚 Neutral: `#2CB3B0`
- Gradient cards with smooth animations
- Dark mode support

## 📱 App Store

Download Petnames by Kinder:

[![App Store](https://img.shields.io/badge/App_Store-Download-blue?logo=apple)](https://apps.apple.com/app/petnames-by-kinder/id6504684930)

## 👨‍💻 Author

**Krijn Haasnoot** - [Kinder](https://apps.apple.com/developer/kerryman-apps/id1492498194)

## 📄 License

This project is proprietary software. All rights reserved.

---

Made with ❤️ for pet lovers everywhere 🐕🐈🐰
