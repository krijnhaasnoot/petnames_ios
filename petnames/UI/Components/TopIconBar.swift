//
//  TopIconBar.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

struct TopIconBar: View {
    let onProfile: () -> Void
    let onFilter: () -> Void
    let onMatches: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onProfile) {
                Image(systemName: "person.crop.circle")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: onFilter) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: onMatches) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundStyle(.pink)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 12)
    }
}

#Preview {
    TopIconBar(
        onProfile: {},
        onFilter: {},
        onMatches: {}
    )
}
