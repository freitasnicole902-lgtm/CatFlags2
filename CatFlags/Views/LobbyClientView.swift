import SwiftUI

struct LobbyClientView: View {

    @ObservedObject var client: RoomClient

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Código da sala")
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.title3.bold())

                    HStack {
                        Spacer()
                        Text(client.screenState?.roomCode ?? "------")
                            .foregroundColor(Color("TextoPrincipal"))
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                        Spacer()
                    }
                    .padding()
                    .background(Color("TextBoxBackground"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("ContornoTextBox"), lineWidth: 1)
                    )
                }

                HStack {
                    Text("Jogadores")
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.title3.bold())
                    Spacer()
                    Text("\(client.screenState?.players.count ?? 0) de \(client.screenState?.maxParticipants ?? 0)")
                        .foregroundColor(Color("TextoSecundario"))
                }

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(client.screenState?.players ?? []) { player in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color("FundoCard1"))
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Text(String(player.nickname.prefix(1)))
                                        .foregroundColor(Color("TextoPrincipal"))
                                        .font(.title2.bold())
                                )
                            Text(player.nickname)
                                .foregroundColor(Color("TextoSecundario"))
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }

                Spacer()

                Text("Aguardando o host iniciar a partida...")
                    .foregroundColor(Color("TextoSecundario"))
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .navigationTitle("Lobby")
        .navigationBarTitleDisplayMode(.inline)
    }
}
