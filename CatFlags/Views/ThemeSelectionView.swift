import SwiftUI

struct ThemeSelectionView: View {

    @State private var selectedTheme: Theme?

    let situations = JSONLoader.loadSituations()

    var body: some View {

        if #available(iOS 16.0, *) {
            NavigationStack {
                
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
                        
                        let filteredCards = situations.filter {
                            $0.theme == selectedTheme
                        }
                        
                        if let firstCard = filteredCards.first {
                            
                            NavigationLink("Ir para o card") {
                                CardView(situation: firstCard)
                            }
                            .padding()
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView()
    }
}
