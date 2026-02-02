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
            
            Text("Versie 1.0")
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Text("© 2026 Krijn Haasnoot")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
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
