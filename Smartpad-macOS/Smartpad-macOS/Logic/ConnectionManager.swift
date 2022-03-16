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
    var displayWidth: CGFloat = 0
    var displayHeight: CGFloat = 0    
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
        let str: String = String.init(data: data, encoding: .utf8)!
        let array = str.components(separatedBy: " ")
        let dx = CGFloat((array[0] as NSString).floatValue)
        let dy = CGFloat((array[1] as NSString).floatValue)

        handleCursorMove(dx: dx, dy: dy)
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
