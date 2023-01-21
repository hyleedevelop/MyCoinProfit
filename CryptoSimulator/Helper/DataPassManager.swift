//
//  DataPassManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/15.
//

import Foundation

final class DataPassManager {
    static let shared = DataPassManager()
    private init() { }
    
    var selectedCoinID: String?
    var selectedCoinName: String?
    var selectedCoinSymbol: String?
}
