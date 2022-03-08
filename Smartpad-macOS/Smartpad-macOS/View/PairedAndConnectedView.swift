//
//  PairedAndConnectedView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct PairedAndConnectedView: View {
    var body: some View {
        ZStack{
            Circle().fill(Color.green).padding(50)
            Text("Connected to: ").foregroundColor(Color.black)
        }
    }
}

struct PairedAndConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        PairedAndConnectedView()
    }
}
