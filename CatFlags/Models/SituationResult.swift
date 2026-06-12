import Foundation

struct SituationResult: Codable {
    let id: Int
    let text: String
    var votes: [FlagType: Int]
}
