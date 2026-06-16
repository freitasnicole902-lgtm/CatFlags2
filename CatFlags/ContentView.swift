import SwiftUI

struct ContentView: View {

    @State private var goToCreate = false
    @State private var goToJoin   = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()

                VStack(spacing: 16) {

                    Spacer()

                    NavigationLink(destination: CreateRoomView(), isActive: $goToCreate) {
                        EmptyView()
                    }

                    NavigationLink(destination: JoinRoomView(), isActive: $goToJoin) {
                        EmptyView()
                    }

                    Button {
                        goToCreate = true
                    } label: {
                        Text("Criar sala")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("BotaoAzul"))
                            .cornerRadius(25)
                    }

                    Button {
                        goToJoin = true
                    } label: {
                        Text("Entrar em sala")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("BotaoAmarelo"))
                            .cornerRadius(25)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
