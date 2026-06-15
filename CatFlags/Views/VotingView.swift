import SwiftUI

struct VotingView: View {

    var body: some View {

        VStack(spacing: 20) {

            Text("Escolha uma flag")

            Button("🔴 Red Flag") { }

            Button("🟡 Yellow Flag") { }

            Button("⚪️ Beige Flag") { }

            Button("🟢 Green Flag") { }

            NavigationLink("Ver resultado") {
                ResultsView(
                    ranking: [
                        SituationResult(
                            id: 1,
                            text: "Minha amiga sente ciúmes quando faço novos amigos.",
                            votes: [:]
                        )
                    ]
                )
            }
        }
    }
}
