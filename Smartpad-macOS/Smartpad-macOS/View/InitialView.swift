//
//  InitialView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct InitialView: View {
    @State private var deviceName = ""
    
    var body: some View {
        VStack{
            Text("<Logo>").padding()
            Spacer()
            Text("Welcome")
            Text("Enter a device name. This name will be shown to other devices for pairing")
            Spacer()
            TextField("Enter name", text: $deviceName).padding()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
