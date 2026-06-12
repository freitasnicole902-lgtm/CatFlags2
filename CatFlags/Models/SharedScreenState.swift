import Foundation

struct SharedScreenState: Codable {
    var phase: GamePhase
    var currentSittuation: Situation?
    var votingTimeRemaining: Int
    var finalRanking: [SituationResult]
}
