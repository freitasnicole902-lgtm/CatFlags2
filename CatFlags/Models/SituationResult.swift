import Foundation

struct SituationResult: Codable,Identifiable {
    let id: Int
    let text: String
    var votes: [FlagType: Int]
}
