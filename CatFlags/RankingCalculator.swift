import Foundation

struct Rankingcalculator {
    static func compute(
        for situations: [Situation],
        votes: [Int: [FlagType: Int]]) ->[SituationResult]{
        situations
            .map{situation in
                SituationResult(
                    id: situation.id,
                    text: situation.text,
                    votes: votes[situation.id] ?? [:]
                )
                
            }.sorted{ a, b in 
                (a.votes[.red] ?? 0) > (b.votes[.red] ?? 0)
                
            }
    }
}
