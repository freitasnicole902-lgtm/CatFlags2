import Foundation

struct Situation: Codable, Identifiable {
    let id: Int
    let theme: Theme
    let text: String
}
