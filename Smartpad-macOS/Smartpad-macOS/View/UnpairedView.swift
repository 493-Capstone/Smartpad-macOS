//
//  UnpairedView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

struct UnpairedView: View {
    var body: some View {
        ZStack{
            Circle().fill(Color.red).padding(50)
            Button("Search for devices", action: {
                print("Search for devices button from UnpairedView")
            }).foregroundColor(Color.black)
        }
    }
}

struct UnpairedView_Previews: PreviewProvider {
    static var previews: some View {
        UnpairedView()
    }
}
