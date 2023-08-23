//
//  HomeViewModel.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 22/08/23.
//

import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var shouldShowNFCNotAvailableView: Bool { get set }
    var shouldShowNFCPadPersonBottomView: Bool { get set }
    var isShowProduct: Bool { get set }
    var product: Product { get set }
    var lastScannedNFCDataValue: String { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    @Published var lastScannedNFCDataValue: String = ""
    
    @Published var shouldShowNFCNotAvailableView = false
    @Published var shouldShowNFCPadPersonBottomView = false
    @Published var isShowProduct = false
    @Published var product = Product()
    
    private var nfcScanner = NFCScanner()
    
    func scanNFC() {
        if nfcScanner.homeViewModel == nil {
            nfcScanner.homeViewModel = self
        }
        nfcScanner.scan()
    }
    
    func stopScanningNFC() {
        nfcScanner.stopScan()
    }
    
    func processNFCCardData(nfcScannedDataValue: String) {
        // Create the HTTP request
        //retrieve data using nfcScannedDataValue, here we are getting DummyDataUsingApi
        DispatchQueue.main.async {
            self.lastScannedNFCDataValue = nfcScannedDataValue
            self.getDummyDataUsingApi(nfcScannedDataValue: nfcScannedDataValue)
        }
        
    }
    
    func getDummyDataUsingApi(nfcScannedDataValue: String) {
        let randomInt = Int.random(in: 0..<30)
        // Create URL
        let url = URL(string: "https://dummyjson.com/products/\(randomInt)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            let decoder = JSONDecoder()
            if let data = data {
                do {
                   let productValue = try decoder.decode(Product.self, from: data)
                    DispatchQueue.main.async {
                        self.product = productValue
                        self.isShowProduct = true
                    }
                    print(self.product)
                } catch {
                    print(error.localizedDescription)
                }
                // Convert HTTP Response Data to a simple String
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
            }
        }
        task.resume()
    }
}
