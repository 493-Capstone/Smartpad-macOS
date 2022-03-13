//
//  SettingsView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct SettingsView: View {
    @State private var enableReverseScrolling = false
    @State private var speed: Double = 50.0
    
    var body: some View {
        VStack{
            Text("Paired to").padding()
            Button("unpair", action: {
                print("unpair button from settingsView")
            })
            Spacer()
            Text("Changing name is not available when paired")
            Spacer()
            Toggle("Reverse Scroll", isOn: $enableReverseScrolling).toggleStyle(.checkbox
            )
            Slider(value: $speed, in: 0...100).padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
