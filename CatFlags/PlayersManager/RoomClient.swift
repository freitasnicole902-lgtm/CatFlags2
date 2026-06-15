import Foundation
import MultipeerConnectivity

class RoomClient: NSObject, ObservableObject {
    
    private let serviceType = "catflags"
    private var browser: MCNearbyServiceBrowser!
    private(set) var session: MCSession!
    let localPeer: MCPeerID
    
    @Published var connectionState: MCSessionState = .notConnected
    @Published var screenState: SharedScreenState?
    @Published var codeRejected: Bool = false
    
    private var discoveredRooms: [(peer: MCPeerID, codeHash: String)] = []
    
    init(nickname: String) {
        self.localPeer = MCPeerID(displayName: nickname)
        super.init()
        
        session = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: localPeer, serviceType: serviceType)
        browser.delegate = self
    }
    
    func startBrowsing(){
        browser.startBrowsingForPeers()
    }
    
    func stopBrowsing(){
        browser.stopBrowsingForPeers()
    }
    
    func joinRoom(code: String, nickname: String){
        let hash = Code.hash(code)
        
        guard let room = discoveredRooms.first(where: {$0.codeHash == hash}) else{
            codeRejected = true
            return
        }
        
        let context = "\(hash)|\(nickname)".data(using: .utf8)
        browser.invitePeer(room.peer, to: session, withContext: context, timeout: 10)
    }
    
    func SendVote(_ color: FlagType) {
        guard !session.connectedPeers.isEmpty else {return}
        guard let data = try? JSONEncoder().encode(Vote(color: color)) else {return}
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    func disconnect(){
        session.disconnect()
        stopBrowsing()
    }
    
}

extension RoomClient: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?){
        guard let codeHash = info?["codeHash"] else {return}
        discoveredRooms.append((peer: peerID, codeHash: codeHash))
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
        discoveredRooms.removeAll {$0.peer == peerID}
    }
    
}

extension RoomClient: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            self.connectionState = state
            
            if state == .notConnected && self.screenState == nil {
                self.codeRejected = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let state = try? JSONDecoder().decode(SharedScreenState.self, from: data) else {return}
        DispatchQueue.main.async{
            self.screenState = state
        }
    }
    
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName:String,
                 fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {}
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {}
    
}
