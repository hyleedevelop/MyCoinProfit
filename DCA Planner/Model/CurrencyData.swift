//
//  CurrencyData.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/26.
//

import Foundation

// MARK: - Coin
struct CurrencyData: Codable {
    let rates: [String: Rate]
}

// MARK: - Rate
struct Rate: Codable {
    //let name, unit: String
    let value: Double
    //let type: TypeEnum
}

//enum TypeEnum: String, Codable {
//    case commodity = "commodity"
//    case crypto = "crypto"
//    case fiat = "fiat"
//}
