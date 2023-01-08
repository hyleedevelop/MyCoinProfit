//
//  CalcManager.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/06.
//

import Foundation

// 날짜와 날짜 사이의 간격(일)을 계산하는 3가지 경우
enum DateIntervalType {
    case buyStartTobuyEnd
    case buyStartToSell
    case buyStartToNow
}

enum DateError {
    case noDateError
    case buyStartDateError
    case buyEndDateError
    case sellDateError
}

final class CalcManager {
    
    // 싱글톤으로 만들기
    static let shared = CalcManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // 주어진 두 날짜 사이의 차이(일) 계산
    func calculateDateInterval(type dateIntervalType: DateIntervalType, start startDateString: String, end endDateString: String?) -> Int {
        
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "KST")
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
        dateInterval = endTime!.timeIntervalSince(startTime!) / Constant.Number.oneDayInSeconds
        return Int(dateInterval)
    }
    
    // 일괄매수 시 ROI(Rate On Investment: 투자이익률), Balance(평가금), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROIIntensive(with historyDict: [String: [[Double?]]], amount amountInvested: Double, buy buyStartDate: String, sell sellDate: String, completion: @escaping ((Double, Double, Double, Double, DateError)) -> Void) {
        var historyTimeArray = [String]()  // "prices" key에서 시간 값을 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격 값을 담기 위한 배열
        
        // API에서 받아온 배열을 새로운 형태의 배열에 넣는 과정
        // 받아온 배열의 구조상 가장 마지막 인덱스의 값의 날짜가 직전 날짜와 중복되므로 for문 반복횟수 -1
        for i in 0..<historyDict["prices"]!.count-1 {
            let historyDate = convertUnixTimestampToDate(from: historyDict["prices"]![i][0] ?? 0.0)
            historyTimeArray.append(historyDate)
            historyPriceArray.append(historyDict["prices"]![i][1] ?? 0.0)
        }
        
        //print(historyTimeArray)
        //print(historyPriceArray)
        //print(buyStartDate)
        //print(sellDate)
        
        // 매수 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기
        guard let buyTimeIndex = historyTimeArray.firstIndex(of: buyStartDate) else {
            completion((0.0, 0.0, 0.0, 0.0, .buyStartDateError))
            return
        }
        // 매도 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기
        guard let sellTimeIndex = historyTimeArray.firstIndex(of: sellDate) else {
            completion((0.0, 0.0, 0.0, 0.0, .sellDateError))
            return
        }
        
        let buyTimePrice: Double = historyPriceArray[buyTimeIndex]  // 매수 날짜 당시 가격
        let sellTimePrice: Double = historyPriceArray[sellTimeIndex]  // 매도 날짜 당시 가격
        
        let roi: Double = (sellTimePrice-buyTimePrice) / buyTimePrice  // 수익률(%)
        let amountReturned: Double = amountInvested * (1+roi)  // 평가금($)
        let profit: Double = amountReturned - amountInvested  // 수익금($)
        
        completion((amountInvested, roi, profit, amountReturned, .noDateError))  // errorCode = 0 (정상)
    }
    
    // 일괄매수 시 ROI(Rate On Investment: 투자이익률), Balance(평가금), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROIAveraged(with historyDict: [String: [[Double?]]], amount amountInvestedOneTime: Double, buyStart buyStartDate: String, buyEnd buyEndDate: String, sell sellDate: String, completion: @escaping ((Double, Double, Double, Double, DateError)) -> Void) {
        var historyTimeArray = [String]()  // "prices" key에서 시간값만 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격값만 담기 위한 배열
        
        // API에서 받아온 배열을 새로운 형태의 배열에 넣는 과정
        // 받아온 배열의 구조상 가장 마지막 인덱스의 값의 날짜가 직전 날짜와 중복되므로 for문 반복횟수 -1
        for i in 0..<historyDict["prices"]!.count-1 {
            let historyDate = convertUnixTimestampToDate(from: historyDict["prices"]![i][0] ?? 0.0)
            historyTimeArray.append(historyDate)
            historyPriceArray.append(historyDict["prices"]![i][1] ?? 0.0)
        }
        
        //print(historyTimeArray)
        //print(historyPriceArray)
        //print(buyStartDate)
        //print(buyEndDate)
        //print(sellDate)
        
        // 매수 시작 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기
        guard let buyStartTimeIndex = historyTimeArray.firstIndex(of: buyStartDate) else {
            completion((0.0, 0.0, 0.0, 0.0, .buyStartDateError))
            return
        }
        // 매수 종료 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기
        guard let buyEndTimeIndex = historyTimeArray.firstIndex(of: buyEndDate) else {
            completion((0.0, 0.0, 0.0, 0.0, .buyEndDateError))
            return
        }
        // 매도 날짜에 해당하는 히스토리 데이터 배열의 인덱스 구하기
        guard let sellTimeIndex = historyTimeArray.firstIndex(of: sellDate) else {
            completion((0.0, 0.0, 0.0, 0.0, .sellDateError))
            return
        }
        
        // 모든 날짜에 해당하는 히스토리 데이터가 있다면 계산 후 결과 반환
        let selectedPriceArray = historyPriceArray[buyStartTimeIndex...buyEndTimeIndex]
        let buyAveragePrice: Double = Double(selectedPriceArray.reduce(0,+)) /
                                      Double(selectedPriceArray.count)  // 분할매수 기간의 평균 매수 가격
        let sellTimePrice: Double = historyPriceArray[sellTimeIndex]  // 매도 날짜 당시 가격
        
        let roi: Double = (sellTimePrice-buyAveragePrice) / buyAveragePrice  // 수익률(%)
        let amountInvested: Double = amountInvestedOneTime *
                                     Double(buyEndTimeIndex-buyStartTimeIndex+1)  // 원금($) = 매 회차 매수 금액 * 매수 횟수
        let amountReturned: Double = amountInvested * (1+roi)  // 평가금($)
        let profit: Double = amountReturned - amountInvested  // 수익금($)
        
        completion((amountInvested, roi, profit, amountReturned, .noDateError))
    }
    
    // Unix Timestamp -> Date 변환
    private func convertUnixTimestampToDate(from timestamp: Double) -> String {
        // 날짜 형식 지정
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        // API에서 받아온 Unix Timestamp는 ms 단위를 가지기 떄문에 s 단위로 변환(/1000)
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
