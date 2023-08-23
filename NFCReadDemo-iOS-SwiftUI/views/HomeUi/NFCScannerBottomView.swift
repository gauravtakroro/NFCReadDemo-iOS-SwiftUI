//
//  NFCScannerBottomView.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 22/08/23.
//

import SwiftUI
import CoreNFC

struct NFCScannerBottomView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Button {
                if NFCNDEFReaderSession.readingAvailable {
                    homeViewModel.scanNFC()
                } else {
                    withAnimation {
                        homeViewModel.shouldShowNFCNotAvailableView.toggle()
                    }
                }
            } label: {
                ZStack {
                    Color("NFCDemoBlue")
                    HStack {
                        Image("waves_signals")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 25)
                            .padding(.trailing, 5)
                    }
                }
                .frame(height: 55)
            }
            .cornerRadius(10)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
}
