//
//  PriceHistoryData.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import Foundation

//MARK: - PriceHistoryData
struct PriceHistoryData: Codable {
    let prices: [[Double]]
    //let marketCaps, totalVolumes: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
        //case marketCaps = "market_caps"
        //case totalVolumes = "total_volumes"
    }
}
