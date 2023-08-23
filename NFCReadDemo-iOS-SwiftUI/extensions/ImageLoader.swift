//
//  ImageLoader.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 23/08/23.
//

import SwiftUI
import Foundation
import UIKit
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        if urlString.isEmpty {
            return
        }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, self != nil else { return }
            DispatchQueue.main.async { [self]
                self?.data = data
            }
        }
        task.resume()
    }
}
