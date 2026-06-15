import Foundation
import MultipeerConnectivity
import CryptoKit

class RoomHost: NSObject, ObservableObject {

    private let serviceType = "catflags"
    private var advertiser: MCNearbyServiceAdvertiser!
    private(set) var session: MCSession!
    let localPeer: MCPeerID

    
    let roomCode: String
    let settings: RoomSettings
    @Published var players: [Player] = []

  
    init(nickname: String, settings: RoomSettings) {
        self.localPeer = MCPeerID(displayName: nickname)
        self.roomCode  = Code.generate()
        self.settings  = settings
        super.init()

        session = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self

        advertiser = MCNearbyServiceAdvertiser(
            peer: localPeer,
            discoveryInfo: [
                "codeHash":   Code.hash(roomCode),
                "theme":      settings.theme.rawValue,
                "maxPlayers": String(settings.numParticipants)
            ],
            serviceType: serviceType
        )
        advertiser.delegate = self

        players.append(Player(id: localPeer.displayName, nickname: nickname))
    }


    func startAdvertising() { advertiser.startAdvertisingPeer() }
    func stopAdvertising()  { advertiser.stopAdvertisingPeer() }
}


extension RoomHost: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {

        // Sala cheia -> rejeita
        guard players.count < settings.numParticipants else {
            invitationHandler(false, nil)
            return
        }

        guard
            let raw       = context.flatMap({ String(data: $0, encoding: .utf8) }),
            let separator = raw.firstIndex(of: "|")
        else {
            invitationHandler(false, nil)
            return
        }

        let sentHash = String(raw[raw.startIndex..<separator])
        let nickname = String(raw[raw.index(after: separator)...])
        let accepted = sentHash == Code.hash(roomCode)

        if accepted {
            DispatchQueue.main.async {
                self.players.append(Player(id: peerID.displayName, nickname: nickname))
            }
        }

        invitationHandler(accepted, accepted ? session : nil)
    }
}


extension RoomHost: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        
        if state == .notConnected {
            DispatchQueue.main.async {
                self.players.removeAll { $0.id == peerID.displayName }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

