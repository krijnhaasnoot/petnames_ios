//
//  NameCardView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct NameCardView: View {
    let name: String
    let setTitle: String
    let gender: String
    let offset: CGSize
    let rotation: Double
    var petImage: UIImage? = PetPhotoManager.shared.petImage
    var namePosition: NamePosition = PetPhotoManager.shared.namePosition
    
    private var genderIcon: String {
        switch gender.lowercased() {
        case "male":
            return "♂"
        case "female":
            return "♀"
        case "neutral":
            return "⚥"
        default:
            return ""
        }
    }
    
    private var gradientColors: [Color] {
        switch gender.lowercased() {
        case "female":
            return [
                Color(hex: "FF2C55"),
                Color(hex: "FF5C7A")
            ]
        case "male":
            return [
                Color(hex: "1491F4"),
                Color(hex: "4DB3FF")
            ]
        case "neutral":
            return [
                Color(hex: "2CB3B0"),
                Color(hex: "5DD4D1")
            ]
        default:
            return [
                Color(hex: "11998E"),
                Color(hex: "38EF7D")
            ]
        }
    }
    
    // Calculate swipe color overlay intensity (0 to 1)
    private var swipeIntensity: Double {
        Double(min(abs(offset.width) / 150.0, 1.0))
    }
    
    // Swipe direction color
    private var swipeColor: Color {
        if offset.width > 0 {
            return Color(hex: "22c55e") // Green for like
        } else if offset.width < 0 {
            return Color(hex: "ef4444") // Red for dismiss
        }
        return .clear
    }
    
    var body: some View {
        ZStack {
            // Card background with swipe color transition
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(swipeColor.opacity(swipeIntensity * 0.7))
                )
                .shadow(color: swipeIntensity > 0.3 ? swipeColor.opacity(0.4) : .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            // Pet photo overlay (25% opacity)
            if let petImage = petImage {
                Image(uiImage: petImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .opacity(0.25)
            }
            
            // Card content - position based on photo analysis
            VStack(spacing: 0) {
                // Top spacer (when name should be at bottom)
                if petImage != nil && namePosition == .bottom {
                    Spacer()
                }
                
                // Name content group
                VStack(spacing: 12) {
                    // Gender indicator
                    Text(genderIcon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    // Name - using Poppins-Black custom font
                    Text(name)
                        .font(.custom("Poppins-Bold", size: 42))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 3)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.horizontal, 20)
                    
                    // Set title
                    Text(setTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(.black.opacity(0.25))
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                }
                .padding(.vertical, petImage != nil ? 30 : 0)
                
                // Bottom spacer (when name should be at top)
                if petImage != nil && namePosition == .top {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Swipe indicators
            if offset.width > 30 {
                likeOverlay
            } else if offset.width < -30 {
                dismissOverlay
            }
        }
        .frame(width: 350, height: 350)
        .offset(offset)
        .rotationEffect(.degrees(rotation))
    }
    
    private var likeOverlay: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color(hex: "22c55e"))
                }
                .rotationEffect(.degrees(-15))
                .opacity(min(Double(offset.width) / 80, 1))
                .scaleEffect(0.8 + min(Double(offset.width) / 300, 0.4))
                
                Spacer()
            }
            Spacer()
        }
        .padding(24)
    }
    
    private var dismissOverlay: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(hex: "ef4444"))
                }
                .rotationEffect(.degrees(15))
                .opacity(min(Double(-offset.width) / 80, 1))
                .scaleEffect(0.8 + min(Double(-offset.width) / 300, 0.4))
            }
            Spacer()
        }
        .padding(24)
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    VStack {
        NameCardView(
            name: "Oliver",
            setTitle: "Classic Names",
            gender: "male",
            offset: .zero,
            rotation: 0
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
}
