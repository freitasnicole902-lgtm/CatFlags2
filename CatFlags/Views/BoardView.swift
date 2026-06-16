import SwiftUI

struct BoardView<Engine: GameStateProtocol>: View {

    @ObservedObject var engine: Engine

    let isHost: Bool
    var host: RoomHost?
    var client: RoomClient?

    var phase: GamePhase {
        let p = isHost
            ? (host?.engine.phase ?? .lobby)
            : (client?.clientEngine.phase ?? .lobby)

        print("BOARDVIEW PHASE =", p)

        return p
    }

    var body: some View {
        switch engine.phase {
        case .lobby:
            if isHost, let host {
                LobbyHostView(host: host, engine: host.engine)
            } else if let client {
                LobbyClientView(client: client)
            }
        case .discussion:
            if isHost, let host {
                DiscussionView(engine: host.engine, isHost: true)
            } else if let client {
                DiscussionView(engine: client.clientEngine, isHost: false)
            }
        case .voting:
            if isHost, let host {
                VotingView(engine: host.engine, isHost: true) { color in
                    host.engine.registerVote(
                        from:       host.localPeer.displayName,
                        color:      color,
                        totalPeers: host.session.connectedPeers.count + 1
                    )
                }
            } else if let client {
                VotingView(engine: client.clientEngine, isHost: false) { color in
                    client.SendVote(color)
                }
            }
        case .results:
            if isHost, let host {
                ResultsView(
                    ranking: host.engine.finalRanking
                )
            } else if let client {
                ResultsView(
                    ranking: client.clientEngine.finalRanking
                )
            }
        }
    }
}
 
