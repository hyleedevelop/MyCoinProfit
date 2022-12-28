//
//  CurrentCurrencyData.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/26.
//

import Foundation

// MARK: - CurrentCurrencyData
struct CurrentCurrencyData: Codable {
    let rates: [String: Rate]
}

// MARK: - Rate
struct Rate: Codable {
    let value: Double
}
