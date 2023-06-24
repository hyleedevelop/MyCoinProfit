//
//  CalcResultData.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/24.
//

import Foundation

struct CalcResultData {
    let principal: Double  // 투자 원금($)
    let roi: Double  // 최종 수익률(%)
    let profit: Double  // 최종 수익금($)
    let balance: Double  // 최종 평가금($)
    let historyPriceArray: [Double]  // 투자기간 동안의 가격 히스토리
    let historyAmountInvestedArray: [Double]  // 투자기간 동안의 원금 히스토리
    let historyROIArray: [Double]  // 투자기간 동안의 수익률 히스토리
    let errorCode: DateError  // 날짜 관련 에러 코드
}
