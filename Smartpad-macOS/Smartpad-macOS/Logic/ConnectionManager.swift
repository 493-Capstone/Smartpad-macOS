//
//  ConnectionManager.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Foundation
import MultipeerConnectivity


class ConnectionManager:NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate{
    var peerName = ""
    var peerID: MCPeerID!
    var p2pSession: MCSession!
    var advertisingSignal: MCNearbyServiceAdvertiser!
    override init(){
        super.init()

        startP2PSession()
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, p2pSession)
    }
    func startP2PSession(){
        peerID = MCPeerID.init(displayName: Host.current().name!)
        p2pSession = MCSession.init(peer: peerID!)
        p2pSession.delegate = self
        advertisingSignal = MCNearbyServiceAdvertiser.init(peer: peerID, discoveryInfo: nil, serviceType: "smartpad")
        advertisingSignal.delegate = self
        advertisingSignal.startAdvertisingPeer()
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        guard let packet = try? decoder.decode(GesturePacket.self, from: data)
        else {
            print("[ConnectionManager] Failed to decode packet!")
            return
        }

//          UNCOMMENT TO SEE ENCODED PACKET AS STRING :-)
//            print(String(data: command, encoding: String.Encoding.utf8))

//        print("Packet - Type: ", packet.touchType!)

//      TODO: HACK UNTIL ALI GETS CONNECTION IN. (normally we would just call some
//            callback here)
        GestureGenerator.getGesture(type: packet.touchType)
                        .performGesture(packet: packet)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
