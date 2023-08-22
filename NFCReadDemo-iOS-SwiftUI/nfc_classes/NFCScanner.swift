//
//  NFCScanner.swift
//  NFCReadDemo-iOS-SwiftUI
//
//  Created by Gaurav Tak on 23/08/23.
//

import Foundation
import CoreNFC

class NFCScanner: NSObject {
    private var session: NFCNDEFReaderSession?
    var homeViewModel: HomeViewModel?

    override init() {
        super.init()
    }

    func scan() {
        if session != nil {
            print("NFC Scanner -> Session not nil")

            session?.invalidate()
            session = nil
        } else {
            session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
            session?.alertMessage = "Hold card/tag upright behind top of device to scan."
            session!.begin()
        }
    }
    
    func stopScan() {
        session?.invalidate()
    }
}

extension NFCScanner: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("NFC Scanner -> Session did become active")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFC Scanner -> tagReaderSession -> Did invalidate with error", error.localizedDescription)
        self.session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        let tag = tags.first!
        switch tag {
        case .feliCa(let felica): print("NFC Scanner -> tagReaderSession -> Felica: ", felica.currentIDm)
        case .iso15693(let newTag): print("NFC Scanner -> tagReaderSession -> iso15693: ", newTag.identifier)
        case .iso7816(let newTag): print("NFC Scanner -> tagReaderSession -> iso7816: ", newTag.identifier)
        case .miFare(let newTag): print("NFC Scanner -> tagReaderSession -> mifare:", newTag.identifier.hexEncodedString())
            print("NFC Scanner -> tagReaderSession -> newTag.mifareFamily = ", newTag.mifareFamily.rawValue)
            print("NFC Scanner -> tagReaderSession -> newTag.historicalBytes = ", newTag.historicalBytes?.hexEncodedString() ?? "")
            session.connect(to: tag) { (_) in

                newTag.readNDEF { (message, _) in
                    print("NFC Scanner -> tagReaderSession -> typeNameFormat = ", message!.records.first!.typeNameFormat.rawValue) // 1 or Format = well known
                    print("NFC Scanner -> tagReaderSession -> ", message!.records.first!.type.hexEncodedString()) // Type = 54 or T for text
                    let firstRecord = message!.records.first! // 7 bytes
                    let decimal = firstRecord.payload.hexEncodedString()
                    print("NFC Scanner -> tagReaderSession -> first record decimal value = ", decimal) // prints "00323031323736"
                    let ascii = String(data: firstRecord.payload, encoding: .ascii)
                    print("NFC Scanner -> tagReaderSession -> first record ascii value = ", ascii ?? "") // prints "\0201276"
                }
            }
        @unknown default:
            print("NFC Scanner -> tagReaderSession -> unknown tag type detected")
        }
        print("NFC Scanner -> Tag Available = ", tag.isAvailable)
    }
}

extension NFCScanner: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC Scanner -> readerSession -> error in NFCNDEFReaderSessionDelegate's readerSession = ", error.localizedDescription)
        self.session?.invalidate()
        self.session = nil
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC Scanner -> readerSession -> Messages =", messages)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        
        print("NFC Scanner -> readerSession -> Tags =", tags)
        guard let tag = tags.first else { return }
        print("NFC Scanner -> readerSession -> Description =", tag.description)
        print("NFC Scanner -> readerSession -> tag.hash =", tag.hash)
        session.connect(to: tag) { (error) in
            if let error = error {
                print("NFC Scanner -> readerSession -> error = ", error)
            }
            tag.readNDEF { (message, error) in
                if let error = error {
                    print("NFC Scanner -> readerSession -> error in readNDEF = ", error)
                }
                if let firstRecord = message?.records.first {
                    let hex = firstRecord.payload.hexEncodedString()
                    print("NFC Scanner -> readerSession -> hex = ", hex)

                    if var tag = String(data: firstRecord.payload, encoding: .utf8) {
                        tag = tag.trimmingCharacters(in: .whitespaces)
                        print("NFC Scanner -> readerSession -> tag = ", tag)
                        self.homeViewModel?.processNFCCardData(nfcScannedDataValue: tag)
                    }
                    self.stopScan()
                }
            }
        }
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("NFC Scanner -> readerSessionDidBecomeActive")
    }
    
   private func stopScanningAndShowInvalidCardAlert() {
        self.stopScan()
    }
}

