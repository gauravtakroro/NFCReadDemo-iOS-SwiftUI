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
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
