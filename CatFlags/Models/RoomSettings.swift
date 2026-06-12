import Foundation

struct RoomSettings: Codable {
    let theme: Theme
    let numParticipants: Int
    let situationsCount: Int
    
    init(theme: Theme, numParticipants: Int, situationsCount: Int) {
        self.theme = theme
        self.numParticipants = numParticipants
        self.situationsCount = min(max(situationsCount, 5), 10)
    }
}
