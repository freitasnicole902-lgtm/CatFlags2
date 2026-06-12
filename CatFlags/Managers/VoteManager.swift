import Foundation

class VoteManager {
    
    private(set) var currentVotes: [String: FlagType] = [:]
    
    private(set) var accumulatedVotes: [Int: [FlagType: Int]] = [:]
    
    func register(from peerID: String, color: FlagType, situationID: Int){
        
        guard currentVotes[peerID] == nil else {return}
        
        currentVotes[peerID] = color
        
        accumulatedVotes[situationID, default: [:]][color, default: 0] += 1
        
    }
    
    func allVoted(expected: Int) -> Bool {
        currentVotes.count == expected
    }
    
    func reset(){
        currentVotes = [:]
    }
    
}
