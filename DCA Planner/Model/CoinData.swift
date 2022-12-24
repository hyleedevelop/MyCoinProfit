//
//  CoinData.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/17.
//

import Foundation

// MARK: - CoinData
struct CoinData: Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Double?
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let priceChangePercentage24HInCurrency: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    }
}

typealias Coin = [CoinData]



//struct CoinData: Codable {
//    let assetID: String?
//    let name: String?
//    let typeIsCrypto: Int
//    //let dataQuoteStart, dataQuoteEnd, dataTradeStart, dataTradeEnd: String
//    //let dataSymbolsCount: Int
//    //let volume1HrsUsd, volume1DayUsd, volume1MthUsd: Double
//    let priceUSD: Double?
//    //let dataStart, dataEnd: String
//
//    enum CodingKeys: String, CodingKey {
//        case assetID = "asset_id"
//        case name = "name"
//        case typeIsCrypto = "type_is_crypto"
//        //case dataQuoteStart = "data_quote_start"
//        //case dataQuoteEnd = "data_quote_end"
//        //case dataTradeStart = "data_trade_start"
//        //case dataTradeEnd = "data_trade_end"
//        //case dataSymbolsCount = "data_symbols_count"
//        //case volume1HrsUsd = "volume_1hrs_usd"
//        //case volume1DayUsd = "volume_1day_usd"
//        //case volume1MthUsd = "volume_1mth_usd"
//        case priceUSD = "price_usd"
//        //case dataStart = "data_start"
//        //case dataEnd = "data_end"
//    }
//}
//
//typealias Coin = [CoinData]
