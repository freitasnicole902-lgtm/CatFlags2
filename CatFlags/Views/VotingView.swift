import SwiftUI

struct VotingView<Engine: GameStateProtocol>: View {

    @ObservedObject var engine: Engine
    let isHost: Bool
    var onVote: ((FlagType) -> Void)?

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 24) {

                //counter
                Text("Card \(engine.currentCardIndex) de \(engine.totalCards)")
                    .foregroundColor(Color("TextoSecundario"))
                    .font(.caption)

                //Timer
                Text(String(format: "0:%02d", engine.votingTimeRemaining))
                    .foregroundColor(Color("BotaoAmarelo"))
                    .font(.system(size: 20, weight: .bold, design: .monospaced))

                //card atual
                if let situation = engine.currentSituation {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("FundoCard1"))

                        Text("\"\(situation.text)\"")
                            .foregroundColor(Color("TextoPrincipal"))
                            .font(.title3.bold())
                            .multilineTextAlignment(.center)
                            .padding(24)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                }

                //botões de voto
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {

                    FlagButton(color: .red,    backgroundColor: "RedFlagCard")    { onVote?(.red)    }
                    FlagButton(color: .yellow, backgroundColor: "YellowFlagCard") { onVote?(.yellow) }
                    FlagButton(color: .beige,  backgroundColor: "BeigeFlagCard")  { onVote?(.beige)  }
                    FlagButton(color: .green,  backgroundColor: "GreenFlagCard")  { onVote?(.green)  }
                }

                Spacer()
            }
            .padding()
        }
    }
}

//botão de flag

struct FlagButton: View {
    let color: FlagType
    let backgroundColor: String
    let action: () -> Void

    @State private var voted = false

    var body: some View {
        Button {
            guard !voted else { return }
            voted = true
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(backgroundColor))
                    .opacity(voted ? 0.5 : 1)
                    .frame(height: 120)

                Image(systemName: "flag.fill")
                    .font(.system(size: 40))
                    .foregroundColor(flagColor)
            }
        }
        .disabled(voted)
    }

    var flagColor: Color {
        switch color {
        case .red:    return Color("RedFlag")
        case .yellow: return Color("YellowFlag")
        case .beige:  return Color("BeigeFlag")
        case .green:  return Color("GreenFlag")
        }
    }
}

