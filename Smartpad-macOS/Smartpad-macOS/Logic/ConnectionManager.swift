//
//  ConnectionManager.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Foundation
import MultipeerConnectivity
/**
 * ConnectionManager handles connectivity states, pairing, and sending/receiving messages.
 *
 * Required for Device Pairing (FR1-FR4), and required for Connection Status (FR15 & FR16)
 */
class ConnectionManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate {
    
    weak var listVC: DeviceListViewController?
    var peerID: MCPeerID!
    var p2pSession: MCSession?
    var peerList: [MCPeerID] = []
    var browser: MCNearbyServiceBrowser?
    weak var mainVC: MainViewController?
    
    override init() {
        super.init()
        startP2PSession()
    }
    
#if LATENCY_TEST_SUITE
    /**
     * Function handles sending messages to device. Here it's only used for testing.
     * Parameter GesturePacket: Value of type GesturePacket to send
     */
    func sendMotion(gesture: GesturePacket) {
        /* We only send packets to the phone for the latency test */
        guard let p2pSession = p2pSession else {return}
        guard !p2pSession.connectedPeers.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            let encoder = JSONEncoder()
            guard let command = try? encoder.encode(gesture)
            else {
                print("[ConnectionManager] Failed to encode packet!")
                return
            }
            
            guard let p2pSession = self.p2pSession else {return}
            try? p2pSession.send(command, toPeers: p2pSession.connectedPeers, with: MCSessionSendDataMode.unreliable)
        }
    }
#endif // LATENCY_TEST_SUITE
    
    /**
     * function initializss MCSession objects
     */
    func startP2PSession() {
        print("start p2p session")
        let connData = ConnectionData()
        peerID = MCPeerID.init(displayName: connData.getDeviceName() + "|" + connData.getCurrentDeviceUUID())
        
        p2pSession = MCSession.init(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        p2pSession?.delegate = self
    }
    
    /**
     * @brief function disconnects peer from session
     */
    func stopP2PSession() {
        guard let p2pSession = p2pSession else {return}
        print("stop p2p session")
        p2pSession.disconnect()
    }
    
    /**
     * Restart the peer-to-peer session. Since the display name cannot be changed while the session
     * is running, this is required whenever we wish to update our display name.
     */
    func restartP2PSession() {
        stopP2PSession()
        startP2PSession()
    }
    
    /**
     * @brief function uses default
     */
    @available(*, deprecated, message: "This method uses the old browser and is deprecated")
    func startJoining() {
        guard let p2pSession = p2pSession else {return}
        guard let listVC = mainVC else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "smartpad", session: p2pSession)
        
        mcBrowser.delegate = self
        mcBrowser.maximumNumberOfPeers = 1
        listVC.presentAsSheet(mcBrowser)
    }
    
    /**
     * Method beings browsing for other peers
     */
    func searchForDevices(){
        /* Restart the session to update our display name */
        restartP2PSession()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "smartpad")
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    /**
     * Method stops browsing for other peers
     */
    func stopSearch(){
        
        browser?.stopBrowsingForPeers()
        clearPeerList()
        guard let listVC = listVC else {
            return
        }
        listVC.dismiss(true)
    }
    
    /**
     * Sends invite to peer at an index in the list.
     * @param[in] index: The index at which the peer is.
     */
    func sendInviteToPeer(index: Int){
        if (index <= peerList.count - 1){
            let peer = peerList[index]
            guard let p2pSession = self.p2pSession else {return}
            browser?.invitePeer(peer, to: p2pSession, withContext: nil, timeout: 30)
            browser?.stopBrowsingForPeers()
            clearPeerList()
        }
    }
    
    /**
     * Disconnects and unpairs the devices
     */
    func unpairDevice(){
        guard let p2pSession = self.p2pSession else {return}
        let connData = ConnectionData()
        connData.setSelectedPeer(name: "")
        p2pSession.disconnect()
        browser?.stopBrowsingForPeers()
        self.mainVC?.updateConnStatus(status: .Unpaired, peerName: "")
    }
    /**
     * empties peerList
     */
    private func clearPeerList(){
        self.peerList = []
    }
    
}

extension ConnectionManager{
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Not used
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Not used
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Not used
    }
    
    /**
     * Session delegate for handling connection status
     */
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // clear peer list once connection status changes
        // indicates pairing attempt
        clearPeerList()
        switch state {
        case .connected:
            print("connected")
            self.stopSearch()
            let connData = ConnectionData()
            connData.setSelectedPeer(name: peerID.displayName)
            self.mainVC?.updateConnStatus(status: ConnStatus.PairedAndConnected, peerName: connData.getSelectedPeer(formatString: true))
#if LATENCY_TEST_SUITE
            /* Kick off latency tests */
            LatencyGesture.self.startTest()
#endif // LATENCY_TEST_SUITE
            
        case .connecting:
            break
            
        case .notConnected:
            // We are still paired, just lost connection. Update the UI to indicate that we are attempting to reconnect
            print("not connected")
            let connData = ConnectionData()
            if (connData.getSelectedPeer() != ""){
                if self.p2pSession?.connectedPeers.count == 0 {
                    self.mainVC?.updateConnStatus(status: ConnStatus.PairedAndDisconnected, peerName: peerID.displayName)
                    self.searchForDevices()
                }
                
            } else {
                self.mainVC?.updateConnStatus(status: ConnStatus.Unpaired, peerName: peerID.displayName)
            }
            
        @unknown default:
            print("unknown state")
        }
    }
    
    /**
     * session delegate for handling received data packets
     */
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue(label:"dataReceive.concurrent.queue", attributes: .concurrent).sync {
            let decoder = JSONDecoder()
            guard let packet = try? decoder.decode(GesturePacket.self, from: data)
            else {
                print("[ConnectionManager] Failed to decode packet!")
                return
            }
            
            GestureGenerator.getGesture(type: packet.touchType)
                .performGesture(packet: packet)
        }
    }
    
    /**
     * browser delegate for scanning and finding nearby peers
     */
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        // update view with new peer
        guard let p2pSession = self.p2pSession else {return}
        let connData = ConnectionData()
        if (connData.getSelectedPeer() != ""){
            if(connData.getSelectedPeer() == peerID.displayName){
                browser.invitePeer(peerID, to: p2pSession, withContext: nil, timeout: 30)
                return
            }
        }
        
        guard let listVC = self.listVC else {return}
        peerList.append(peerID)
        
        listVC.updateTable()
    }
    
    /**
     * browser delegate to detect when a peer is no longer available
     */
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer lostPeerID: MCPeerID) {
        
        self.peerList = peerList.filter {$0.displayName != lostPeerID.displayName}
        // update view with new list
        guard let listVC = self.listVC else {return}
        
        listVC.updateTable()
    }
    
    /**
     * Delegate for handling default browser for peers.
     * Now deprecated.
     */
    @available(*, deprecated, message: "No longer in use")
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    /**
     * Delegate for handling default browser for peers.
     * Now deprecated.
     */
    @available(*, deprecated, message: "No longer in use")
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    
}
