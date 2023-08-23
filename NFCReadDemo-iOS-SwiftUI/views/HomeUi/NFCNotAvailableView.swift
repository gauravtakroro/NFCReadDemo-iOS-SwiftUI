//
//  NFCNotAvailableView.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 21/08/23.
//

import SwiftUI

struct NFCNotAvailableView: View {
    @Binding var shouldShowNFCNotAvailableView: Bool
    var body: some View {
        ZStack {
            Color("NFCDemoWhite")
            VStack(alignment: .center) {
                
                Text("NFC Scanning Not Available").bold().padding(.top, 16)
                Text("NFC scanning feature is not available for this device due to hardware limitations")
                    .lineLimit(nil)
                    .foregroundColor(Color("NFCDemoBlack")).padding(.all, 16)
                
                Button(action: {
                    withAnimation {
                        shouldShowNFCNotAvailableView.toggle()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("NFCDemoBlue"))
                        Text("Okay")
                            .font(.system(size: 18))
                            .foregroundColor(Color("NFCDemoWhite"))
                    }
                    .padding([.leading, .trailing], 28)
                }
                .frame(height: 45)
            }
        }
    }
}

struct NFCNotAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        NFCNotAvailableView(shouldShowNFCNotAvailableView: .constant(false))
    }
}
