import Foundation

protocol GameStateProtocol: ObservableObject {
    var phase:               GamePhase      { get }
    var currentSituation:    Situation?     { get }
    var timeRemaining:       Int            { get }
    var votingTimeRemaining: Int            { get }
    var finalRanking:        [SituationResult] { get }
    var currentCardIndex:    Int            { get }
    var totalCards:          Int            { get }
    
    func addThirtySeconds()
    func forceStartVoting()
}
