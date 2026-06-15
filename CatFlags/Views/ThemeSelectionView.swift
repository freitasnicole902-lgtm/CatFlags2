import SwiftUI
import MultipeerConnectivity

struct ThemeSelectionView: View {

    @State private var selectedTheme: Theme?

    @State private var numParticipants = 3

    @State private var nickname = ""
    
    let situations = JSONLoader.loadSituations()

    var body: some View {

      
            NavigationView {
                
                VStack(spacing: 20) {
                    
                    Text("Escolha o tema:")
                        .font(.largeTitle)
                    
                    Stepper(
                        "Jogadores: \(numParticipants)",
                        value:$numParticipants,
                        in: 3...8
                    )
                    .padding()
                    
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
                            
                            NavigationLink("Criar Sala") {
                                CardView(situation: firstCard)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
            // Fallback on earlier versions
}

struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView()
    }
}
