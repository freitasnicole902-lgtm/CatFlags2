import Foundation
import MultipeerConnectivity

class GameEngine: ObservableObject {
    
    private let flow: GameFlowController
    let votes: VoteManager
    
    @Published var phase: GamePhase = .lobby
    @Published var currentPhase: Situation?
    @Published var timeRemaining: Int = 300
    @Published var votingTimeRemaining: Int = 30
    @Published var finalRanking: [SituationResult] = []
    
    init(session: MCSession, settings: RoomSettings){
        
        let Deck = SituationsDeck()
        let timer = GameTimer()
        let votes = VoteManager()
        let broadcaster = GameBroadcaster(session: session)
        
        self.votes = votes
        self.flow = GameFlowController(deck: Deck, timer: timer, votes: votes, broadcaster: broadcaster, settings: settings)
        
        flow.onStateChange = { [ weak self ] phase, situation, timeRemaining, votingTime, ranking in
            
            self?.phase = phase
            self?.currentPhase = situation
            self?.timeRemaining = timeRemaining
            self?.votingTimeRemaining = votingTime
            self?.finalRanking = ranking
            
        }
        
        func startGame(allSituations: [Situation]) {
            flow.start(allSituations: allSituations)
        }
        
        func addThirtySeconds() {flow.addThirtySeconds()}
        
        func forceStartVoting() {flow.startVoting()}
        
        func skipSituation() {flow.skipSituation()}
        
        func registerVote(from peerID: String, color: FlagType, totalPeers: Int){
            flow.registerVote(from: peerID, color: color, totalPeers: totalPeers)
        }
        
    }
    
}
