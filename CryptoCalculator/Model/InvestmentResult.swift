//
//  InvestmentResult.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/22.
//

import UIKit

enum InvestmentType: Int {
    case intensiveInvestment = 0
    case averagedInvestment
}

protocol InvestmentResult { }

struct IntensiveInvestment: InvestmentResult {
    let amount: Double
    let roi: Double
    let profit: Double
    let balance: Double
    
    let coinTypeString: String
    let buyStartDateString: String
    let sellDateString: String
    
    let buyStartToSellLength: Int
    
    let historyPriceArray: [Double]
    let historyAmountInvestedArray: [Double]
    let historyROIArray: [Double]
}

struct AveragedInvestment: InvestmentResult {
    let amount: Double
    let roi: Double
    let profit: Double
    let balance: Double
    
    let coinTypeString: String
    let buyStartDateString: String
    let buyEndDateString: String
    let sellDateString: String
    let frequencyString: String
    let amountString: String
    
    let buyStartTobuyEndLength: Int
    let buyStartToSellLength: Int
    
    let historyPriceArray: [Double]
    let historyAmountInvestedArray: [Double]
    let historyROIArray: [Double]
}
