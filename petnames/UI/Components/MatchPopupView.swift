//
//  MatchPopupView.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct MatchPopupView: View {
    let name: String
    let gender: String
    let onViewMatches: () -> Void
    let onContinue: () -> Void
    
    @State private var animateHearts = false
    @State private var animateScale = false
    
    // Gender-based colors (matching NameCardView)
    private var gradientColors: [Color] {
        switch gender.lowercased() {
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
    
    private var primaryColor: Color {
        gradientColors[0]
    }
    
    private var secondaryColor: Color {
        gradientColors[1]
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onContinue()
                }
            
            // Popup card
            VStack(spacing: 0) {
                // Header with gender-based gradient
                ZStack {
                    // Gradient background
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Floating hearts
                    ZStack {
                        ForEach(0..<6, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .font(.system(size: CGFloat.random(in: 16...28)))
                                .foregroundStyle(.white.opacity(0.3))
                                .offset(
                                    x: CGFloat.random(in: -100...100),
                                    y: animateHearts ? CGFloat.random(in: -60...20) : CGFloat.random(in: 0...40)
                                )
                                .animation(
                                    .easeInOut(duration: Double.random(in: 1.5...2.5))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: animateHearts
                                )
                        }
                    }
                    
                    VStack(spacing: 8) {
                        // Match icon - always red heart
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 64, height: 64)
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color(hex: "FF2C55"))
                                .scaleEffect(animateScale ? 1.1 : 1.0)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true),
                                    value: animateScale
                                )
                        }
                        
                        Text("It's a Match!")
                            .font(.custom("Poppins-Bold", size: 24))
                            .foregroundStyle(.white)
                        
                        Text("Jullie vinden allebei")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                }
                .frame(height: 150)
                
                // Name display - compact
                VStack(spacing: 4) {
                    Text(name)
                        .font(.custom("Poppins-Bold", size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: primaryColor.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Text("geweldig! 🎉")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                
                // Buttons with gender colors
                VStack(spacing: 10) {
                    Button {
                        onViewMatches()
                    } label: {
                        Text("Bekijk alle matches")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        onContinue()
                    } label: {
                        Text("Verder swipen")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(primaryColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .stroke(primaryColor, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(UIColor.systemBackground))
            }
            .frame(width: 350)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
            .scaleEffect(animateScale ? 1.0 : 0.9)
        }
        .onAppear {
            animateHearts = true
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                animateScale = true
            }
        }
    }
}

#Preview("Female") {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        MatchPopupView(name: "Luna", gender: "female", onViewMatches: {}, onContinue: {})
    }
}

#Preview("Male") {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        MatchPopupView(name: "Max", gender: "male", onViewMatches: {}, onContinue: {})
    }
}

#Preview("Neutral") {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        MatchPopupView(name: "Charlie", gender: "neutral", onViewMatches: {}, onContinue: {})
    }
}
