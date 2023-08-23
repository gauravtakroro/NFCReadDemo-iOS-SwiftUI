//
//  ProductView.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 23/08/23.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    @Binding var product: Product
    @Binding var nfcCardDataValue: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Scanned NFC Card Value: \(nfcCardDataValue)").font(.system(size: 16))
            Text("Scanned Product Details").font(.system(size: 24))
            
            HStack {
                if product.thumbnail != nil && product.thumbnail?.isEmpty == false {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:120, height:120)
                        .onReceive(imageLoader.didChange) { data in
                            self.image = UIImage(data: data) ?? UIImage()
                        }
                }
                Spacer()
                VStack (alignment: .leading) {
                    if let title = product.title {
                        Text("Title : \(title)").fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if let price = product.price {
                        Text("Price : \(Int(price))").frame(alignment: .leading)
                        if let discountPercentage = product.discountPercentage {
                            Text("Discounted Price : \(Int(price - discountPercentage/100.0 * price))")
                        }
                    }
                    if let rating = product.rating {
                        Text("Rating : \(String(format: "%.2f", rating)) Out of 5")
                    }
                }
            }
            if let description = product.description {
                Text("Description : \(description)").multilineTextAlignment(.leading).fixedSize(horizontal: false, vertical: true)
            }
            if let brand = product.brand {
                Text("Brand : \(brand)")
            }
        }.padding(.top, 32)
    }
}
