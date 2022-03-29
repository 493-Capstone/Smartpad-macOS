//
//  ConnectionManager.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager:NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate{
    weak var pairVC: MainViewController?
    var peerID: MCPeerID!
    var p2pSession: MCSession?
    var peerList: [MCPeerID] = []

    override init(){
        super.init()        
      
        startP2PSession()
    }

    func startP2PSession(){
        let connData = ConnectionData()
        peerID = MCPeerID.init(displayName: connData.getDeviceName())
        p2pSession = MCSession.init(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        p2pSession?.delegate = self
    }
    
    func stopP2PSession(){
        guard let p2pSession = p2pSession else {return}
        p2pSession.disconnect()
    }
    
    func startJoining(){
        guard let p2pSession = p2pSession else {return}
        guard let listVC = pairVC else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "smartpad", session: p2pSession)

        mcBrowser.delegate = self
        mcBrowser.maximumNumberOfPeers = 1
        listVC.presentAsSheet(mcBrowser)
    }
}

extension ConnectionManager{
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected:
                print("Connected: \(peerID.displayName)")
                DispatchQueue.main.async {
                    self.pairVC?.setPairLabel(label: "Connected: \(peerID.displayName)")
                    self.pairVC?.updateConnectionView(status: ConnStatus.PairedAndConnected)
                }
            
            case .connecting:
                print("Connecting: \(peerID.displayName)")
                DispatchQueue.main.async {
                    self.pairVC?.setPairLabel(label: "Connecting: \(peerID.displayName)")
                    self.pairVC?.updateConnectionView(status: ConnStatus.PairedAndDisconnected)
                }
            case .notConnected:
                print("notConnected: \(peerID.displayName)")
                DispatchQueue.main.async {
                    self.pairVC?.setPairLabel(label: "Disconnected: \(peerID.displayName)")
                    self.pairVC?.updateConnectionView(status: ConnStatus.Unpaired)
                }
        @unknown default:
            print("unknown state")
        }
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
    
//             print("Packet - Type: ", packet.touchType!)

            GestureGenerator.getGesture(type: packet.touchType)
                            .performGesture(packet: packet)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        pairVC!.dismiss(browserViewController)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        pairVC!.dismiss(browserViewController)
    }
}
