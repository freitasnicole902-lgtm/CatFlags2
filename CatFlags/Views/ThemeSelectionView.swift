import SwiftUI

struct ThemeSelectionView: View {

    @State private var selectedTheme: Theme?

    var body: some View {

        VStack(spacing: 20) {

            Text("Escolha o tema:")
                .font(.largeTitle)

            Button("❤️ Amor") {
                selectedTheme = .love
            }

            Button("👨‍👩‍👧 Família") {
                selectedTheme = .family
            }

            Button("🤝 Amigos") {
                selectedTheme = .friendship
            }

            Button("👥 Geral") {
                selectedTheme = .general
            }

            if let selectedTheme {

                Text("Tema selecionado: \(selectedTheme.rawValue)")
            }
        }
    }
}

struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView()
    }
}
