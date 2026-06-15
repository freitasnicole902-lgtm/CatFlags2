import SwiftUI

struct ThemeButton: View {
    let theme: Theme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .black : .white)
                Text(label)
                    .font(.caption)
                    .foregroundColor(isSelected ? .black : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color("F5A623") : Color("2C2C2C"))
            .cornerRadius(12)
        }
    }

    var iconName: String {
        switch theme {
        case .love:   return "heart.fill"
        case .friendship: return "person.2.fill"
        case .family:     return "house.fill"
        case .general:    return "globe"
        }
    }

    var label: String {
        switch theme {
        case .love:   return "Amor"
        case .friendship: return "Amizade"
        case .family:     return "Família"
        case .general:    return "Geral"
        }
    }
}
