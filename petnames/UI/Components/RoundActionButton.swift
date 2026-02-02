//
//  RoundActionButton.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI

enum ActionButtonType {
    case dislike
    case undo
    case like
    
    var icon: String {
        switch self {
        case .dislike:
            return "hand.thumbsdown.fill"
        case .undo:
            return "arrow.uturn.backward"
        case .like:
            return "hand.thumbsup.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .dislike:
            return .red
        case .undo:
            return .gray
        case .like:
            return .green
        }
    }
    
    var size: CGFloat {
        switch self {
        case .undo:
            return 50
        default:
            return 64
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .undo:
            return 20
        default:
            return 28
        }
    }
}

struct RoundActionButton: View {
    let type: ActionButtonType
    let action: () -> Void
    let disabled: Bool
    
    init(type: ActionButtonType, disabled: Bool = false, action: @escaping () -> Void) {
        self.type = type
        self.disabled = disabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(disabled ? Color.gray.opacity(0.3) : type.color.opacity(0.15))
                    .frame(width: type.size, height: type.size)
                
                Circle()
                    .strokeBorder(disabled ? Color.gray.opacity(0.5) : type.color, lineWidth: 2)
                    .frame(width: type.size, height: type.size)
                
                Image(systemName: type.icon)
                    .font(.system(size: type.iconSize, weight: .semibold))
                    .foregroundStyle(disabled ? Color.gray : type.color)
            }
        }
        .disabled(disabled)
        .scaleEffect(disabled ? 0.95 : 1.0)
        .animation(.spring(response: 0.3), value: disabled)
    }
}

#Preview {
    HStack(spacing: 32) {
        RoundActionButton(type: .dislike) {}
        RoundActionButton(type: .undo, disabled: true) {}
        RoundActionButton(type: .like) {}
    }
    .padding()
}
