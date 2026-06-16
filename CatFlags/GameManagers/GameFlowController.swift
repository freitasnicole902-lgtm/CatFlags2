import Foundation
import MultipeerConnectivity

class GameFlowController {

    private let deck:        SituationsDeck
    private let timer:       GameTimer
    private let votes:       VoteManager
    private let broadcaster: GameBroadcaster
    private let settings:    RoomSettings
    private let roomCode:    String
    private let maxParticipants: Int
    private(set) var players: [Player]
    private var currentCardIndex: Int = 0
    private var totalCards: Int = 0


    var onStateChange: ((
        _ phase:               GamePhase,
        _ situation:           Situation?,
        _ timeRemaining:       Int,
        _ votingTimeRemaining: Int,
        _ finalRanking:        [SituationResult],
        _ currentCardIndex:    Int,
        _ totalCards:          Int
    ) -> Void)?


    private var phase:               GamePhase = .lobby
    private var currentSituation:    Situation?
    private var timeRemaining:       Int = 300
    private var votingTimeRemaining: Int = 30
    private var finalRanking:        [SituationResult] = []

    init(
        deck:        SituationsDeck,
        timer:       GameTimer,
        votes:       VoteManager,
        broadcaster: GameBroadcaster,
        settings:    RoomSettings,
        roomCode:    String,
        players:     [Player]
    ) {
        self.deck           = deck
        self.timer          = timer
        self.votes          = votes
        self.broadcaster    = broadcaster
        self.settings       = settings
        self.roomCode       = roomCode
        self.maxParticipants = settings.numParticipants
        self.players        = players
    }

  //Atualiza players e trasmite pro cliente ver no lobby

    func updatePlayers(_ newPlayers: [Player]) {
        players = newPlayers
        broadcast()
    }

    //Início

    func start(allSituations: [Situation]) {
        deck.draw(from: allSituations, theme: settings.theme, count: settings.situationsCount)
        totalCards = settings.situationsCount
        currentCardIndex = 0
        showNextSituation()
    }


    // Todo o fluxo aq

    private func showNextSituation() {
        currentCardIndex += 1
        guard
            let situation = deck.next()

        else {
            endGame()
            return
        }

        votes.reset()
        currentSituation = situation
        phase = .discussion
        timeRemaining = 300

        notifyStateChange()
        broadcast()

        timer.startDiscussion(duration: 300) { [weak self] secondsLeft in
            self?.timeRemaining = secondsLeft
            self?.notifyStateChange()
            self?.broadcast()  // faz broadcast a cdaa seg
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

        timer.startVoting(duration: 30) { [weak self] secondsLeft in
            self?.votingTimeRemaining = secondsLeft
            self?.notifyStateChange()
            self?.broadcast()
        } onFinish: { [weak self] in
            self?.advanceToNext()
        }
    }

    private func advanceToNext() {
        timer.stop()
        showNextSituation()
    }

    private func endGame() {
        timer.stop()
        phase = .results
        finalRanking = Rankingcalculator.compute(for: deck.played, votes: votes.accumulatedVotes)
        notifyStateChange()
        broadcast()
    }

    // controle do host

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

        if votes.allVoted(expected: totalPeers) {
            advanceToNext()
        }
    }

    //nnotifica o GameEngine

    private func notifyStateChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onStateChange?(
                self.phase,
                self.currentSituation,
                self.timeRemaining,
                self.votingTimeRemaining,
                self.finalRanking,
                self.currentCardIndex,
                self.totalCards
            )

        }
    }

    // broadcast

    private func broadcast() {
        let state = SharedScreenState(
            phase:               phase,
            currentSituation:    currentSituation,
            votingTimeRemaining: votingTimeRemaining,
            finalRanking:        finalRanking,
            players:             players,
            roomCode:            roomCode,
            maxParticipants:     maxParticipants,
            currentCardIndex:    currentCardIndex,
            totalCards:          totalCards
        )
        broadcaster.send(state)
    }
}

