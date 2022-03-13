//
//  DevicesFoundView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct DevicesFoundView: View {
    struct Device: Identifiable {
        let name: String
        let id = UUID()
    }
    private var devicesFound = [
        Device(name: "device 1"),
        Device(name: "device 2"),
        Device(name: "device 3")]
    @State private var selectedDevice = ""
    var body: some View {
        VStack{
            Text("Devices found").padding()
            List(devicesFound){
//                Button($0.name, action: ($0) {
//                    selectedDevice = $0.name
//                })
                Text($0.name)
            }
            Spacer()
            Button("Cancel", action: {
                print("cancel button from devicesFoundView")
            }).padding()
        }
    }
}

struct DevicesFoundView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesFoundView()
    }
}
