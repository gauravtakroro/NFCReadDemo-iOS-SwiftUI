//
//  HomeView.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 22/08/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        VStack {
            Image("app_icon_small")
            Text("NFC Demo").font(.system(size: 20))
            Text("please tap bottom button for NFC card/tag scanning").padding(.top, 8).font(.system(size: 14))
            if viewModel.isShowProduct {
                ProductView(imageLoader: ImageLoader(urlString: viewModel.product.thumbnail ?? ""), product: $viewModel.product, nfcCardDataValue: $viewModel.lastScannedNFCDataValue)
            } else {
                Spacer()
                Text("No NFC Card is scanned yet.").padding(.top, 64).font(.system(size: 20)).foregroundColor(Color.gray.opacity(0.8))
            }
            if viewModel.shouldShowNFCNotAvailableView {
                NFCNotAvailableView(shouldShowNFCNotAvailableView: $viewModel.shouldShowNFCNotAvailableView)
                    .frame(width: 300, height: 240)
                    .opacity(viewModel.shouldShowNFCNotAvailableView ? 1.0 : 0.0)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Spacer()
            }
            NFCScannerBottomView(homeViewModel: viewModel).frame(maxHeight: .infinity, alignment: .bottom).padding(.bottom, 16)
        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

