import SwiftUI

struct JoinRoomView: View {

    @State private var code = ""
    @State private var nickname = ""
    @State private var client: RoomClient?
    @State private var isJoined = false

    var body: some View {
        if isJoined {
            Text("Lobby Cliente")
        } else {
            content
        }
    }

    var codeField: some View {
        let field = TextField("", text: $code)
            .foregroundColor(Color("TextoPrincipal"))
            .font(.system(size: 24, weight: .bold, design: .monospaced))
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.characters)
            .onChange(of: code) { newValue in
                code = String(newValue.uppercased().filter {
                    $0.isLetter || $0.isNumber
                }.prefix(6))
            }

        return field
            .padding()
            .background(Color("TextBoxBackground"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("ContornoTextBox"), lineWidth: 1)
            )
    }


    var content: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("TextoPrincipal"))
                    }
                    Spacer()
                    Text("Entrar em sala")
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.headline)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Código da sala")
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.title3.bold())
                    codeField
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Seu nome")
                        .foregroundColor(Color("TextoPrincipal"))
                        .font(.title3.bold())

                    TextField("", text: $nickname)
                        .foregroundColor(Color("TextoPrincipal"))
                        .padding()
                        .background(Color("TextBoxBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("ContornoTextBox"), lineWidth: 1)
                        )
                }

                if let client, client.codeRejected {
                    Text("Código inválido ou sala não encontrada")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer()

                Button {
                    let newClient = RoomClient(nickname: nickname)
                    newClient.startBrowsing()
                    client = newClient

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        newClient.joinRoom(code: code, nickname: nickname)
                    }
                } label: {
                    Text("Entrar")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            canJoin ? Color("BotaoAmarelo") : Color("TextoSecundario")
                        )
                        .cornerRadius(32)
                }
                //.disabled(!canJoin)
            }
            .padding()
        }
        .onChange(of: client?.connectionState.rawValue) { _ in
            if client?.connectionState == .connected {
                isJoined = true
            }
        }
    }

    var canJoin: Bool {
        !code.trimmingCharacters(in: .whitespaces).isEmpty &&
        !nickname.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
