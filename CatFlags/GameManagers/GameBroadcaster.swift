import Foundation
import MultipeerConnectivity

//guarda uma ref a session(objt)
class GameBroadcaster {
    private let session: MCSession
    
    init(session: MCSession) {
        self.session = session
    }
    
    func send(_ state: SharedScreenState) {
        //se nao tiver ngm conectado nao manda nada
        guard !session.connectedPeers.isEmpty else {return}
        guard let data = try? JSONEncoder().encode(state) else {return}
        //.reliabe garante que o pct cehga na ordem certa e sem perda
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}
