struct SharedScreenState: Codable {
    var phase:               GamePhase
    var currentSituation:    Situation?
    var votingTimeRemaining: Int
    var finalRanking:        [SituationResult]
    var players:             [Player]       
    var roomCode:            String
    var maxParticipants:     Int
    var currentCardIndex: Int
    var totalCards: Int
}
