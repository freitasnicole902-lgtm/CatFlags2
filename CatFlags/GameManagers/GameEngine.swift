import Foundation
import MultipeerConnectivity

class GameEngine: ObservableObject {

    private(set) var flow: GameFlowController  // private(set) pra RoomHost acessar
    let votes: VoteManager

    @Published var phase:               GamePhase = .lobby
    @Published var currentSituation:    Situation?
    @Published var timeRemaining:       Int = 300
    @Published var votingTimeRemaining: Int = 30
    @Published var finalRanking:        [SituationResult] = []
    @Published var currentCardIndex: Int = 0
    @Published var totalCards: Int = 0


    init(session: MCSession, settings: RoomSettings, roomCode: String, players: [Player]) {

        let deck        = SituationsDeck()
        let timer       = GameTimer()
        let votes       = VoteManager()
        let broadcaster = GameBroadcaster(session: session)

        self.votes = votes
        self.flow  = GameFlowController(
            deck:           deck,
            timer:          timer,
            votes:          votes,
            broadcaster:    broadcaster,
            settings:       settings,
            roomCode:       roomCode,
            players:        players
        )

        flow.onStateChange = { [weak self] phase, situation, timeRemaining, votingTime, ranking, cardIndex, total in
            self?.phase               = phase
            self?.currentSituation    = situation
            self?.timeRemaining       = timeRemaining
            self?.votingTimeRemaining = votingTime
            self?.finalRanking        = ranking
            self?.currentCardIndex    = cardIndex
            self?.totalCards          = total
        }
    }

    func startGame(allSituations: [Situation])                          { flow.start(allSituations: allSituations) }
    func addThirtySeconds()                                             { flow.addThirtySeconds()                  }
    func forceStartVoting()                                             { flow.startVoting()                       }
    func skipSituation()                                                { flow.skipSituation()                     }
    func registerVote(from peerID: String, color: FlagType, totalPeers: Int) {
        flow.registerVote(from: peerID, color: color, totalPeers: totalPeers)
    }
}

extension GameEngine: GameStateProtocol {}
