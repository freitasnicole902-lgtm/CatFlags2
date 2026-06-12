import Foundation
import MultipeerConnectivity

class GameFlowController {
    
    private let deck: SituationsDeck
    private let timer: GameTimer
    private let votes: VoteManager
    private let broadcaster: GameBroadcaster
    private let settings: RoomSettings
    
    var onStateChange: ((_
        phase: GamePhase,_
        Situation: Situation?,_
        timeRemaining: Int,_
        votingTimeRemaining: Int,_
        finalRanking: [SituationResult]
    ) -> Void)?
    
    private var phase: GamePhase = .lobby
    private var currentSituation: Situation?
    private var timeRemaining: Int = 300
    private var votingTimeRemaining: Int = 30
    private var finalRanking: [SituationResult] = []
    
    init(
        deck: SituationsDeck,
        timer: GameTimer,
        votes: VoteManager,
        broadcaster: GameBroadcaster,
        settings: RoomSettings,
    ){
        self.deck = deck
        self.timer = timer
        self.votes = votes
        self.broadcaster = broadcaster
        self.settings = settings
    }
    
    func start(allSituations: [Situation]){
        deck.draw(from: allSituations, theme: settings.theme, count: settings.situationsCount)
        showNextSituation()
    }
    
    private func showNextSituation(){
        guard let situation = deck.next() else {
            endGame()
            return
        }
        votes.reset()
        currentSituation = situation
        phase = .discussion
        timeRemaining = 300
        
        notifyStateChange()
        broadcast()
        
        timer.startDiscussion(duration: 300){[weak self] secondsLeft in
            self?.timeRemaining = secondsLeft
            self?.notifyStateChange()
        } onFinish: { [weak self] in
            self?.startVoting()
        }
    }
    
    func startVoting() {
        timer.stop()
        phase = .voting
        votingTimeRemaining = 30
        
        notifyStateChange()
        broadcast()
        
        timer.startVoting(duration: 30){[weak self] secondsLeft in
            self?.votingTimeRemaining = secondsLeft
            self?.notifyStateChange()
            self?.broadcast()
        } onFinish: {[weak self] in
            self?.advanceToNext()
        }
    }
    
    private func advanceToNext() {
        timer.stop()
        showNextSituation()
    }
    
    private func endGame(){
        timer.stop()
        phase = .results
        finalRanking = Rankingcalculator.compute(for: deck.played, votes: votes.accumulatedVotes)
        notifyStateChange()
        broadcast()
    }
    
    func addThirtySeconds() {
        timer.addTime(30)
        timeRemaining += 30
        notifyStateChange()
    }
    
    func skipSituation() {
        timer.stop()
        advanceToNext()
    }
    
    func registerVote(from peerID: String, color: FlagType, totalPeers: Int) {
        guard let situation = currentSituation else { return }
        votes.register(from: peerID, color: color, situationID: situation.id)
        
        if votes.allVoted(expected: totalPeers){
            advanceToNext()
        }
    }
    
    private func notifyStateChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            self.onStateChange?(
                self.phase,
                self.currentSituation,
                self.timeRemaining,
                self.votingTimeRemaining,
                self.finalRanking
            )
        }
    }
    
    private func broadcast() {
        let state = SharedScreenState(
            phase: phase,
            currentSittuation: currentSituation,
            votingTimeRemaining: votingTimeRemaining,
            finalRanking: finalRanking
        )
        broadcaster.send(state)
    }
}
