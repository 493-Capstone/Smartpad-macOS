//
//  PairedAndDisconnectedView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct PairedAndDisconnectedView: View {
    var body: some View {
        ZStack{
            Circle().fill(Color.yellow).padding(50)
            Text("iOS device not found...\nattempting to reconnect").foregroundColor(Color.black)
        }
    }
}

struct PairedAndDisconnectedView_Previews: PreviewProvider {
    static var previews: some View {
        PairedAndDisconnectedView()
    }
}
