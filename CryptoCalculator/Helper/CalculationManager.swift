//
//  CalculationManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/06.
//

import Foundation

//MARK: - Enum 선언
//                             <Timeline (ex: Bitcoin)>
//
//     O-----------------O-----------------O-----------------O-----------------O
// 2013-04-28       buyStartDate       buyEndDate         sellDate            Now

// 날짜와 날짜 사이의 간격(일)을 계산하는 3가지 경우
enum DateIntervalType {
    case buyStartTobuyEnd  // 매수 시작 날짜 ~ 매수 종료 날짜 간격
    case buyStartToSell  // 매수 시작 날짜 ~ 매도 날짜 간격
    case buyStartToNow  // 매수 시작 날짜 ~ 현재(fetching 하는 시점) 날짜 간격
}

// 날짜 계산을 할 수 없는 경우에 대한 에러 타입
enum DateError {
    case noDateError  // 에러 없음
    case buyStartDateError  // 매수 시작 날짜로 인한 에러
    case buyEndDateError  // 매수 종료 날짜로 인한 에러
    case sellDateError  // 매도 날짜로 인한 에러
}

//MARK: - 각종 스탯 계산을 담당하는 매니저

final class CalculationManager {
    
    // 싱글톤으로 만들기
    static let shared = CalculationManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // 주어진 두 날짜 사이의 차이(일) 계산
    func calculateDateInterval(type dateIntervalType: DateIntervalType, start startDateString: String, end endDateString: String?) -> Int {
        
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = Constant.DateSetting.standardTimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        let nowDateString = formatter.string(from: nowDate)
        
        var startTime, endTime: Date?
        
        switch dateIntervalType {
        case .buyStartTobuyEnd:
            if let start = formatter.date(from: startDateString) { startTime = start }
            if let end = formatter.date(from: endDateString!) { endTime = end }
        case .buyStartToSell:
            if let start = formatter.date(from: startDateString) { startTime = start }
            if let end = formatter.date(from: endDateString!) { endTime = end }
        case .buyStartToNow:
            if let start = formatter.date(from: startDateString) { startTime = start }
            if let end = formatter.date(from: nowDateString) { endTime = end }
        }
        
        var dateInterval: Double = 0.0
        // startTime부터 endTime까지의 시간 간격을 86400(초)로 나누어 일 단위로 변환
        dateInterval = endTime!.timeIntervalSince(startTime!) / Constant.UnitSetting.oneDayInSeconds
        return Int(dateInterval)
    }
    
    // 일괄매수 시 ROI(Rate On Investment: 투자이익률), Balance(평가금), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROIIntensive(with historyDict: [String: [[Double?]]], principal: Double, buy buyStartDate: String, sell sellDate: String) async -> CalcResultData? {
        var historyTimeArray = [String]()  // "prices" key에서 시간 값을 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격 값을 담기 위한 배열
        var historyROIArray = [Double]()  // ROI 추이를 담기 위한 배열
        var historyAmountInvestedArray = [Double]()  // 투자원금 추이를 담기 위한 배열
        
        // API에서 받아온 배열을 새로운 형태의 배열에 넣는 과정
        // 받아온 배열의 구조상 가장 마지막 인덱스의 값의 날짜가 직전 날짜와 중복되므로 for문 반복횟수 -1
        for i in 0..<historyDict["prices"]!.count-1 {
            let historyDate = (historyDict["prices"]![i][0] ?? 0.0).convertUnixTimestampToDate()
            historyTimeArray.append(historyDate)
            historyPriceArray.append(historyDict["prices"]![i][1] ?? 0.0)
        }
        
        // 매수 시작 날짜에 해당하는 히스토리 데이터 배열의 인덱스
        let buyTimeIndex = 0
        
        // 매도 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기 (에러 발생 시 계산 중단)
        guard let sellTimeIDX = historyTimeArray.firstIndex(of: sellDate) else { return nil }
        let sellTimeIndex = Int(sellTimeIDX.description)!
        
        let buyTimePrice: Double = historyPriceArray[buyTimeIndex]  // 매수 날짜 당시 가격
        //let sellTimePrice: Double = historyPriceArray[sellTimeIndex]  // 매도 날짜 당시 가격
        
        for i in 0..<historyDict["prices"]!.count-1 {
            historyROIArray.append((historyPriceArray[i] - buyTimePrice) / buyTimePrice)
            historyAmountInvestedArray.append(principal)
        }
        
        let roi: Double = historyROIArray[sellTimeIndex]  // 최종 수익률(%)
        let balance: Double = principal * (1 + roi)  // 최종 평가금($)
        let profit: Double = balance - principal  // 최종 수익금($)
        
        return CalcResultData(
            principal: principal,
            roi: roi,
            profit: profit,
            balance: balance,
            historyPriceArray: historyPriceArray,
            historyAmountInvestedArray: historyAmountInvestedArray,
            historyROIArray: historyROIArray,
            errorCode: .noDateError
        )
    }
    
    // 일괄매수 시 ROI(Rate On Investment: 투자이익률), Balance(평가금), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROIAveraged(with historyDict: [String: [[Double?]]], principalPerDay: Double, buyStart buyStartDate: String, buyEnd buyEndDate: String, sell sellDate: String) async ->  CalcResultData? {
        var historyTimeArray = [String]()  // "prices" key에서 시간값만 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격값만 담기 위한 배열
        var historyCoinAmountArray = [Double]()  // 보유하고 있는 코인 개수를 담기 위한 배열
        var historyROIArray = [Double]()  // ROI 추이를 담기 위한 배열
        var historyAmountInvestedArray = [Double]()  // 투자원금 추이를 담기 위한 배열
        var historyAverageCost = [Double]()  // 매수기간동안 매일의 평균매수가를 담기 위한 배열
        
        // API에서 받아온 배열을 새로운 형태의 배열에 넣는 과정
        // 받아온 배열의 구조상 가장 마지막 인덱스의 값의 날짜가 직전 날짜와 중복되므로 for문 반복횟수 -1
        for i in 0..<historyDict["prices"]!.count-2 {
            let historyDate = (historyDict["prices"]![i][0] ?? 0.0).convertUnixTimestampToDate()
            historyTimeArray.append( historyDate )
            historyPriceArray.append( historyDict["prices"]![i][1] ?? 0.0 )
        }
        
        // 매수 시작 날짜에 해당하는 히스토리 데이터 배열의 인덱스
        let buyStartTimeIndex = 0
        
        // 매수 종료 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기 (에러 발생 시 계산 중단)
        guard let buyEndTimeIDX = historyTimeArray.firstIndex(of: buyEndDate) else { return nil }
        let buyEndTimeIndex = Int(buyEndTimeIDX.description)!
        
        // 매도 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기 (에러 발생 시 계산 중단)
        guard let sellTimeIDX = historyTimeArray.firstIndex(of: sellDate) else { return nil }
        let sellTimeIndex = Int(sellTimeIDX.description)!
        
        // 매수 시작 날짜부터 매수 종료 날짜까지 매일 매수에 사용된 누적 원금과 평균 매수가 구하기
        for i in buyStartTimeIndex...buyEndTimeIndex {
            historyAmountInvestedArray.append( Double(i + 1) * principalPerDay )
            historyCoinAmountArray.append( principalPerDay / historyPriceArray[i] )
        }
        
        // (1) 매수 시작 날짜부터 매도 날짜까지의 계산
        for i in buyStartTimeIndex...buyEndTimeIndex {
            historyAverageCost.append( historyAmountInvestedArray[i]
                                       / historyCoinAmountArray[0...i].reduce(0,+) )
            historyROIArray.append( (historyPriceArray[i] - historyAverageCost.last!)
                                    / historyAverageCost.last! )
        }
        
        // (2) 매수 종료 날짜부터 매도 날짜까지의 계산
        for i in buyEndTimeIndex+1...sellTimeIndex {
            historyAmountInvestedArray.append( historyAmountInvestedArray.last! )
            historyCoinAmountArray.append( historyCoinAmountArray.last! )
            historyAverageCost.append( historyAverageCost.last! )
            historyROIArray.append( (historyPriceArray[i] - historyAverageCost.last!)
                                    / historyAverageCost.last! )
        }
        
        let roi: Double = historyROIArray.last!  // 최종 수익률(%)
        let amountInvested: Double = historyAmountInvestedArray.last!  // 최종 원금($)
        let balance: Double = amountInvested * (1 + roi)  // 최종 평가금($)
        let profit: Double = balance - amountInvested  // 최종 수익금($)
        
        return CalcResultData(
            principal: amountInvested,
            roi: roi,
            profit: profit,
            balance: balance,
            historyPriceArray: historyPriceArray,
            historyAmountInvestedArray: historyAmountInvestedArray,
            historyROIArray: historyROIArray,
            errorCode: .noDateError
        )
    }
    
}
