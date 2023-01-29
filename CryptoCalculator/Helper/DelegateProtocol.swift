//
//  DelegateProtocol.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/11.
//

import Foundation


// 0: 원금  1: 수익률  2: 수익금  3: 평가금
// 4: 코인이름  5: 매수날짜  6: 매도날짜
// 7: 매수시작~매도 기간의 날짜 수
// 8: 코인가격 배열  9: 매수원금 배열, 10: 수익률 배열

// (amount, roi, profit, balance,
//  coinTypeString, buyStartDateString, sellDateString,
//  buyStartToSellLength,
//  historyPriceArray, historyAmountInvestedArray, historyROIArray,)

typealias CalcResultType1 = (Double, Double, Double, Double,
                             String, String, String,
                             Int,
                             [Double], [Double], [Double])

// 0: 원금  1: 수익률  2: 수익금  3: 평가금
// 4: 코인이름  5: 매수시작날짜  6: 매수종료날짜  7: 매도날짜  8: 매수주기  9: 매번 매수할 금액
// 10: 매수시작~매수종료 기간의 날짜 수  11: 매수시작~매도 기간의 날짜 수
// 12: 코인가격 배열  13: 매수원금 배열, 14: 수익률 배열

// (amount, roi, profit, balance,
//  coinTypeString, buyStartDateString, buyEndDateString, sellDateString, frequencyString, amountString,
//  buyStartTobuyEndLength, buyStartToSellLength,
//  historyPriceArray, historyAmountInvestedArray, historyROIArray)

typealias CalcResultType2 = (Double, Double, Double, Double,
                             String, String, String, String, String, String,
                             Int, Int,
                             [Double], [Double], [Double])

protocol CalcResultDelegate: AnyObject {
    func receiveCalcResultData(segmentIndex index: Int, with data: Any)
}
