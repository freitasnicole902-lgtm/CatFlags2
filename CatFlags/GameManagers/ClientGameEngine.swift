import Foundation

class ClientGameEngine: ObservableObject {

    @Published var phase: GamePhase = .lobby
    @Published var currentSituation: Situation?
    @Published var timeRemaining: Int = 300
    @Published var votingTimeRemaining: Int = 30
    @Published var finalRanking: [SituationResult] = []
    @Published var currentCardIndex: Int = 0
    @Published var totalCards: Int = 0

    func update(from state: SharedScreenState) {
        phase = state.phase
        currentSituation = state.currentSituation
        votingTimeRemaining = state.votingTimeRemaining
        finalRanking = state.finalRanking
        currentCardIndex = state.currentCardIndex
        totalCards = state.totalCards
    }

    func addThirtySeconds() {
        // Cliente não faz nada
    }

    func forceStartVoting() {
        // Cliente não faz nada
    }
}

extension ClientGameEngine: GameStateProtocol {}
