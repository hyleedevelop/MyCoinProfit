//
//  DelegateProtocol.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/11.
//

import Foundation


// (0: 원금  1: 수익률  2: 수익금  3: 평가금
//  4: 코인이름  5: 매수날짜  6: 매도날짜)
// (amount, roi, profit, balance,
//  coinTypeString, buyStartDateString, sellDateString)
typealias CalcResultType1 = (Double, Double, Double, Double,
                             String, String, String)

// (0: 원금  1: 수익률  2: 수익금  3: 평가금
//  4: 코인이름  5: 매수시작날짜  6: 매수종료날짜  7: 매도날짜  8: 매수주기  9: 매번 매수할 금액)
// (amount, roi, profit, balance,
//  coinTypeString, buyStartDateString, buyEndDateString, sellDateString, frequencyString, amountString)
typealias CalcResultType2 = (Double, Double, Double, Double,
                             String, String, String, String, String, String)

protocol CalcResultDelegate: AnyObject {
    func receiveCalcResultData(segmentIndex index: Int, with data: Any)
}
