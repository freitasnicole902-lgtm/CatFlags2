import SwiftUI

struct CreateRoomView: View {

   @State private var nickname = ""
   @State private var selectedTheme: Theme = .love
   @State private var maxParticipants: Double = 3
   @State private var situationCount: Double = 5
    @State private var host: RoomHost?
    @State private var isRoomCreated = false

   var body: some View {
       if isRoomCreated, let host {
               LobbyHostView(host: host, engine: host.engine!)
           } else {
               content
           }
   }

   var content: some View {
       ZStack {
           Color("Background")
               .ignoresSafeArea()

           VStack(alignment: .leading, spacing: 32) {
               
               HStack {
                   Button(action: {}) {
                       Image(systemName: "chevron.left")
                           .foregroundColor(Color("TextoPrincipal"))
                   }
                   Spacer()
                   Text("Configurações da sala")
                       .foregroundColor(Color("TextoPrincipal"))
                       .font(.headline)
                   Spacer()
               }

               VStack(alignment: .leading, spacing: 8) {
                   Text("Seu apelido")
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

               VStack(alignment: .leading, spacing: 16) {
                   Text("Escolha o tema")
                       .foregroundColor(Color("TextoPrincipal"))
                       .font(.title3.bold())

                   HStack(spacing: 12) {
                       ForEach(Theme.allCases, id: \.self) { theme in
                           ThemeButton(
                               theme: theme,
                               isSelected: selectedTheme == theme
                           ) {
                               selectedTheme = theme
                           }
                       }
                   }
               }

               VStack(alignment: .leading, spacing: 8) {
                   HStack {
                       Text("Nº Jogadores")
                           .foregroundColor(Color("TextoPrincipal"))
                           .font(.title3.bold())
                       Spacer()
                       Text("\(Int(maxParticipants)) de 8")
                           .foregroundColor(Color("TextoSecundario"))
                   }
                   Slider(value: $maxParticipants, in: 2...8, step: 1)
                       .tint(Color("BotaoAmarelo"))
               }

               VStack(alignment: .leading, spacing: 8) {
                   HStack {
                       Text("Nº Cards")
                           .foregroundColor(Color("TextoPrincipal"))
                           .font(.title3.bold())
                       Spacer()
                       Text("\(Int(situationCount)) de 10")
                           .foregroundColor(Color("TextoSecundario"))
                   }
                   Slider(value: $situationCount, in: 5...10, step: 1)
                       .tint(Color("BotaoAmarelo"))
               }

               Spacer()

               Button {
                   let settings = RoomSettings(
                       theme:           selectedTheme,
                       numParticipants: Int(maxParticipants),
                       situationsCount: Int(situationCount)
                   )
                   let newHost = RoomHost(nickname: nickname, settings: settings)
                   newHost.startAdvertising()
                   
                   DispatchQueue.main.async {
                       host = newHost
                       isRoomCreated = true
                   }
               } label: {
                   Text("Criar sala")
                       .font(.headline.bold())
                       .foregroundColor(.black)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(
                           nickname.trimmingCharacters(in: .whitespaces).isEmpty
                           ? Color("BotaoAmarelo")
                           : Color("BotaoAmarelo")
                       )
                       .cornerRadius(32)
               }
               .disabled(nickname.trimmingCharacters(in: .whitespaces).isEmpty)
           }
           .padding()
       }
   }
}
