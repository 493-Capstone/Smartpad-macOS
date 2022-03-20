//
//  ConnectionManager.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Foundation
import MultipeerConnectivity


class ConnectionManager:NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate{
    weak var listVC: NSViewController?
    var peerName = ""
    var peerID: MCPeerID!
    var p2pSession: MCSession!
    var advertisingSignal: MCNearbyServiceAdvertiser!
    var displayWidth: CGFloat = 0
    var displayHeight: CGFloat = 0
    var peerList: [MCPeerID] = []
    var invitations: [(Bool, MCSession?) -> Void] = []
    override init(){
        super.init()
        let screens = NSScreen.screens
        for screen in screens {
            displayWidth = max(NSWidth(screen.frame), displayWidth)
            displayHeight = max(NSHeight(screen.frame), displayHeight)
        }
        
        startP2PSession()
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(peerID.displayName)
        if(!peerList.contains(peerID)){
            peerList.append(peerID)
            (listVC as? DeviceSelectionViewController)?.deviceList = peerList.map({(i: MCPeerID) -> String in return i.displayName })
            (listVC as? DeviceSelectionViewController)?.deviceListView.reloadData()
        }
        invitations.append(invitationHandler)
        // TODO: Should be removed once pairing is complete
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
    
    func requestPairingForDevice(peerName: String){
        guard let peerIndex = peerList.firstIndex(where: {$0.displayName == peerName}) else { return }
        print(peerIndex)
        print("request pairing")
        // TODO: Only accept request peer's invitation
//        invitations[peerIndex](true, p2pSession) // accept invite
        DispatchQueue.main.async {
            let encoder = JSONEncoder()
            guard let command = try? encoder.encode("invite")
            else {
                print("[ConnectionManager] Failed to encode packet!")
                return
            }
            try? self.p2pSession.send(command, toPeers: self.p2pSession.connectedPeers, with: MCSessionSendDataMode.unreliable)
        }
        
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

        print("Packet - Type: ", packet.touchType!)

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
    func handleCursorMove(dx: CGFloat, dy: CGFloat) {
        let gain = CGFloat(2.0)
        var mouseLocation = NSEvent.mouseLocation
        mouseLocation = CGPoint(x: mouseLocation.x + dx * gain, y: displayHeight - mouseLocation.y + dy * gain)
        mouseLocation.x = min(max(0, mouseLocation.x), displayWidth)
        mouseLocation.y = min(max(0, mouseLocation.y), displayHeight)
        let source = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent.init(mouseEventSource: source, mouseType: .mouseMoved, mouseCursorPosition: mouseLocation, mouseButton: .left)
        event?.post(tap: .cghidEventTap)
    }
    

}
