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

final class CalcManager {
    
    // 싱글톤으로 만들기
    static let shared = CalcManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
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
        //dateInterval += 1
        return Int(dateInterval)
    }
    
    // ROI(Rate On Investment: 투자이익률), Balance(평가금), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROI(segment segmentIndex: Int, with historyDict: [String: [[Double?]]],
                      amount amountInvested: Double, start buyStartDate: String, end sellDate: String,
                      completion: @escaping ((Double, Double, Double, Double)) -> Void) {
        
        var historyTimeArray = [String]()  // "prices" key에서 시간값만 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격값만 담기 위한 배열
        
        // API에서 받아온 배열을 새로운 형태의 배열에 넣는 과정
        // 받아온 배열의 구조상 가장 마지막 인덱스의 값의 날짜가 직전 날짜와 중복되므로 for문 반복횟수 -1
        for i in 0..<historyDict["prices"]!.count-1 {
            let historyDate = convertUnixTimestampToDate(from: historyDict["prices"]![i][0] ?? 0.0)
            historyTimeArray.append(historyDate)
            historyPriceArray.append(historyDict["prices"]![i][1] ?? 0.0)
        }
        
        guard let buyTimeIndex = historyTimeArray.firstIndex(of: buyStartDate) else { return }
        guard let sellTimeIndex = historyTimeArray.firstIndex(of: sellDate) else { return }
        
        let buyTimePrice: Double = historyPriceArray[buyTimeIndex]
        let sellTimePrice: Double = historyPriceArray[sellTimeIndex]
        
        if segmentIndex == 0 {
            print("<일괄매수 수익 계산 결과>")
            let roi: Double = (sellTimePrice-buyTimePrice) / buyTimePrice  // 수익률(%)
            let amountReturned: Double = amountInvested * (1+roi)  // 투자 후 자산
            let profit: Double = amountReturned - amountInvested  // 투자 후 수익금
            completion((amountInvested, roi, profit, amountReturned))
        }
        
        if segmentIndex == 1 {
            print("<분할매수 수익 계산 결과>")
            //let secondSegmentROI = 0.0
            //completion(secondSegmentROI, secondSegmentROI, secondSegmentROI)
        }

    }
    
    // Unix Timestamp -> Date 변환
    private func convertUnixTimestampToDate(from timestamp: Double) -> String {
        // API에서 받아온 Unix Timestamp는 ms 단위를 가지기 떄문에 s 단위로 변환하기(/1000)
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let dateString = formatter.string(from: date)
        return dateString
    }
    
//    // Date -> Unix Timestamp 변환
//    private func convertDateToUnixTimestamp(from date: String) -> TimeInterval {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(abbreviation: "KST")
//        formatter.dateFormat = "yyyy-MM-dd"
//
//        //let timestampStringArray = timestampDoubleArray.map { String($0) }
//        let unixTimestamp = formatter.date(from: date)!.timeIntervalSince1970
//        return unixTimestamp
//    }
    
}
