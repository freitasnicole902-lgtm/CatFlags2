import SwiftUI

struct DiscussionView<Engine: GameStateProtocol>: View {

    @ObservedObject var engine: Engine
    let isHost: Bool

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // cards
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
                    .frame(height: 280)
                }

                //Timer circular
                ZStack {
                    Circle()
                        .stroke(Color("FundoCard1"), lineWidth: 8)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: CGFloat(engine.timeRemaining) / 300)
                        .stroke(Color("GreenFlag"), lineWidth: 8)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 120, height: 120)
                        .animation(.linear(duration: 1), value: engine.timeRemaining)

                    Text(timeFormatted(engine.timeRemaining))
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                }

                Text("Discutam em grupo antes do tempo acabar")
                    .foregroundColor(Color("TextoSecundario"))
                    .font(.caption)
                    .multilineTextAlignment(.center)

                Spacer()

                // Botões de host
                if isHost {
                    HStack(spacing: 16) {
                        Button {
                            engine.addThirtySeconds()
                        } label: {
                            Text("+30s")
                                .font(.headline.bold())
                                .foregroundColor(Color("TextoPrincipal"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("FundoCard1"))
                                .cornerRadius(32)
                        }

                        Button {
                            engine.forceStartVoting()
                        } label: {
                            Text("Iniciar votação")
                                .font(.headline.bold())
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("GreenFlag"))
                                .cornerRadius(32)
                        }
                    }
                }
            }
            .padding()
        }
    }

    func timeFormatted(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

