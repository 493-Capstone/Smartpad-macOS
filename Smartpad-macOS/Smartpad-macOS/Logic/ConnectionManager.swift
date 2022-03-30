//
//  ConnectionManager.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager:NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate{


    weak var listVC: DeviceListViewController?
    var peerID: MCPeerID!
    var p2pSession: MCSession?
    var peerList: [MCPeerID] = []
    var browser: MCNearbyServiceBrowser?
    weak var mainVC: MainViewController?

    override init(){
        super.init()
        startP2PSession()
    }

    func startP2PSession(){
        print("start p2p session")
        let connData = ConnectionData()
        peerID = MCPeerID.init(displayName: connData.getDeviceName())
        p2pSession = MCSession.init(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        p2pSession?.delegate = self
    }
    
    func stopP2PSession(){
        guard let p2pSession = p2pSession else {return}
        p2pSession.disconnect()
    }
    
    /**
     
     */
    @available(*, deprecated, message: "This method uses the old browser and is deprecated")
    func startJoining(){
        guard let p2pSession = p2pSession else {return}
        guard let listVC = mainVC else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "smartpad", session: p2pSession)

        mcBrowser.delegate = self
        mcBrowser.maximumNumberOfPeers = 1
        listVC.presentAsSheet(mcBrowser)
    }
    

    /**
     Method beings browsing for other peers
     */
    func searchForDevices(){
        guard let p2pSession = p2pSession else {return}
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "smartpad")
//        print("start browsing for peers")
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    /**
     Method stops browsing for other peers
     */
    func stopSearch(){

        browser?.stopBrowsingForPeers()
//        print("stop browsing for peers")
        clearPeerList()
        listVC!.dismiss(true)
    }
    
    
    func sendInviteToPeer(index: Int){
        if (index <= peerList.count - 1){
            let peer = peerList[index]
            guard let p2pSession = self.p2pSession else {return}
            browser?.invitePeer(peer, to: p2pSession, withContext: nil, timeout: 30)
            browser?.stopBrowsingForPeers()
            clearPeerList()
        }
    }
    
    private func clearPeerList(){
        self.peerList = []
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
        // clear peer list once connection status changes
        // indicates pairing attempt
        clearPeerList()
        switch state {
            case .connected:
//                print("Connected: \(peerID.displayName)")
                self.mainVC?.updateConnStatus(status: ConnStatus.PairedAndConnected, peerName: peerID.displayName)
            
            case .connecting:
                break
                // Just stay in the same state, UI will be hidden while we are connected anyways.
//                print("Connecting: \(peerID.displayName)")
//                self.mainVC?.updateConnStatus(status: ConnStatus.PairedAndDisconnected, peerName: peerID.displayName)

            case .notConnected:
//                print("notConnected: \(peerID.displayName)")
                /* We are still paired, just lost connection. Update the UI to indicate that we are attempting to reconnect */
                self.mainVC?.updateConnStatus(status: ConnStatus.PairedAndDisconnected, peerName: peerID.displayName)
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

    
    // Callbacks for the peer browser
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

        // update view with new peer
        guard let listVC = self.listVC else {return}
        peerList.append(peerID)
        
        listVC.updateTable()
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer lostPeerID: MCPeerID) {
        
        self.peerList = peerList.filter {$0.displayName != lostPeerID.displayName}
        // update view with new list
        guard let listVC = self.listVC else {return}
     
        listVC.updateTable()
    }
    
    
    
    @available(*, deprecated, message: "No longer in use")
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    @available(*, deprecated, message: "No longer in use")
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    
}
