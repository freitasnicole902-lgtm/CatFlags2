import Foundation

class SituationsDeck {
    private(set) var played: [Situation] = []
    private var remaining: [Situation] = []
    
    func draw(from all: [Situation], theme: Theme,count: Int){
        let filtered = all.filter{ $0.theme == theme}
        let shuffled = filtered.shuffled()
        remaining = Array(shuffled.prefix(count))
        played = []
    }
    
    func next() -> Situation?{
        guard !remaining.isEmpty else {return nil}
        let situation = remaining.removeFirst()
        played.append(situation)
        return situation
    }
}
