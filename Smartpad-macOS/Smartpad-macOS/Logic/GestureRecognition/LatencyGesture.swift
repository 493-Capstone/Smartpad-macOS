//
//  LatencyGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-04-04.
//

/**
 * Latency tester. Used to validate our wireless connectivity performance.
 *
 * See the test plans for instructions on enabling the latency tester.
 */

#if LATENCY_TEST_SUITE

import Foundation

class LatencyGesture : Gesture {
    private static let decoder = JSONDecoder()
    private static let type = GestureType.Latency

    /* Number of packets to receive before printing the stats */
    private static let printInterval: UInt64 = 5000

    /* The id of the last packet */
    private static var lastPacketId: UInt64 = 0

    /**
     * Latency stats
     */
    /* Number of missed packets */
    private static var numMissedPackets: UInt64 = 0
    /* Sum of total latency (used for calcluating running average */
    private static var totalLatency = TimeInterval(0)
    private static var average = TimeInterval(0)
    private static var max = TimeInterval(0)
    private static var min = TimeInterval(0xFFFFFFFF)
    /* Timestamp of the previously sent message */
    private static var lastTime = TimeInterval(0)

    /* Watchdog for missed packets. Fires after 1s of no packet received back. */
    private static var timer: Timer?

    /* Called to start the test */
    static func startTest() {
        /* Reset all variables */
        lastPacketId = 0
        numMissedPackets = 0
        totalLatency = TimeInterval(0)
        average = TimeInterval(0)
        max = TimeInterval(0)
        min = TimeInterval(0xFFFFFFFF)
        lastTime = TimeInterval(0)

        sendNextPacket()
    }

    /* Called whenever a packet did not make it back to us */
    @objc static func packetWasMissed() {
        numMissedPackets += 1
        sendNextPacket()
    }

    /* Send the next test packet */
    static private func sendNextPacket() {
        /* Arm watchdog */
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: LatencyGesture.self, selector: #selector(packetWasMissed), userInfo: nil, repeats: false)

        let encoder = JSONEncoder()

        var packet: GesturePacket!
        let payload = LatencyPayload(packetId: lastPacketId)
        let encPayload = try? encoder.encode(payload)

        packet = GesturePacket(touchType: .Latency, payload: encPayload)

        lastTime = Date().timeIntervalSince1970
        ConnectionManagerAccess.connectionManager.sendMotion(gesture: packet)
    }

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        /* Extract timestamp */
        guard let payload = try? decoder.decode(LatencyPayload.self, from: packet.payload)
        else {
            print("[LatencyTester] Failed to decode payload!")
            return
        }

        let currentTime = Date().timeIntervalSince1970

        /* We can't have received a packet from the future */
        assert(currentTime >= lastTime)

        /* We should have received the same packet we sent */
        assert(lastPacketId == payload.packetId)

        /* Divde latency by 2 because we are sending then receiving back the same packet */
        updateStats(latency: (currentTime - lastTime) / 2, packetId: payload.packetId)
    }

    /**
     * Update the internally-stored stats with the new sample
     */
    static private func updateStats(latency: TimeInterval, packetId: UInt64) {
        /* Update the latency stats */

        if (latency > max) {
            max = latency
        }

        if (latency < min) {
            min = latency
        }

        totalLatency += latency
        average = totalLatency / Double(lastPacketId)

        if (lastPacketId % printInterval == 0 && lastPacketId != 0) {
            /* Print results periodically */
            print("Num packets received: ", lastPacketId)
            print("Num packets missed: ", numMissedPackets)
            print("===========================================")
            print("% packets received: ", (lastPacketId)/(lastPacketId + numMissedPackets) * 100)
            print("===========================================")

            print("===========================================")
            print("Latency stats: ")
            print("Average latency (s): ", average)
            print("Max latency (s): ", max)
            print("Min latency (s): ", min)
            print("===========================================")
        }

        lastPacketId += 1
        sendNextPacket()
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return (type == gestureType)
    }
}

#endif // LATENCY_TEST_SUITE
