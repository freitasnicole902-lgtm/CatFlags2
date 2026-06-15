//
//  LobbyHostView.swift
//  CatFlags
//
//  Created by Academy on 15/06/26.
//
//import SwiftUI
//
//struct HostLobbyView: View {
//
//    @ObservedObject var host: RoomHost
//
//    var body: some View {
//
//        VStack(spacing: 20) {
//
//            Text("Código da sala")
//                .font(.headline)
//
//            Text(host.roomCode)
//                .font(.largeTitle)
//
//            Text("Jogadores")
//
//            List(host.players) { player in
//                Text(player.nickname)
//            }
//
//            Button("Iniciar partida") {
//
//            }
//        }
//    }
//}
//
//#Preview {
//    LobbyHostView()
//}

import SwiftUI

struct LobbyHostView: View {
    
    @ObservedObject var host: RoomHost
    @ObservedObject var engine: GameEngine
    @State private var gameStarted = false
    

   var body: some View {
       if gameStarted {
           Text("Jogo") 
       } else {
           content
       }
   }

   var content: some View {
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
                       Text(host.roomCode)
                           .foregroundColor(Color("TextoPrincipal"))
                           .font(.system(size: 32, weight: .bold, design: .monospaced))
                       Spacer()
                       Button {
                           UIPasteboard.general.string = host.roomCode
                       } label: {
                           Image(systemName: "doc.on.doc")
                               .foregroundColor(Color("TextoPrincipal"))
                       }
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
                   Text("\(host.players.count) de \(host.settings.numParticipants)")
                       .foregroundColor(Color("TextoSecundario"))
               }

               LazyVGrid(columns: [
                   GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())
               ], spacing: 16) {
                   ForEach(host.players) { player in
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

               Button {
                   let all = JSONLoader.loadSituations()
                   engine.startGame(allSituations: all)
                   gameStarted = true
               } label: {
                   Text("Iniciar partida")
                       .font(.headline.bold())
                       .foregroundColor(.black)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color("BotaoAmarelo"))
                       .cornerRadius(32)
               }
           }
           .padding()
       }
       .navigationTitle("Lobby")
       .navigationBarTitleDisplayMode(.inline)

   }
}

