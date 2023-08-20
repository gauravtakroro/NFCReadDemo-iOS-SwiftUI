//
//  ContentView.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 21/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var shouldShowNFCNotAvailableView = false
    var body: some View {
        VStack {
            Image("app_icon_small")
            Text("NFC Demo").padding(.top, 16)
            // Nfc not available view
            NFCNotAvailableView(shouldShowNFCNotAvailableView: $shouldShowNFCNotAvailableView)
                .frame(width: 300, height: 240)
                .opacity(shouldShowNFCNotAvailableView ? 1.0 : 0.0)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
