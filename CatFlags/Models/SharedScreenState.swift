import Foundation

struct SharedScreenState: Codable {
    var phase: GamePhase
    var currentSituation: Situation?
    var votingTimeRemaining: Int
    var finalRanking: [SituationResult]
}
