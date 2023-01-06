//
//  CalcManager.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/06.
//

import Foundation

final class CalcManager {
    
    // 싱글톤으로 만들기
    static let shared = CalcManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // 두 날짜의 차이 일수 계산
    func calculateDateInterval(start startTimeString: String, end endTimeString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let startTime = formatter.date(from: startTimeString) else { return 0}
        guard let endTime = formatter.date(from: endTimeString) else { return 0 }
        
        let numberOfDays = endTime.timeIntervalSince(startTime) / Constant.Number.oneDayInSeconds
        
        return Int(numberOfDays)
    }
    
    // ROI(Rate On Investment: 투자이익률), Balance(평가금액), Profit(수익금) 계산
    // 계산 후 달러나 퍼센트 형식의 문자열로 변환 후 반환
    func calculateROI(segment segmentIndex: Int, with historyDict: [String: [[Double]]],
                      completion: @escaping ((String, String, String, String)) -> Void) {
        
        var historyTimeArray = [Double]()  // "prices" key에서 시간값만 담기 위한 배열
        var historyPriceArray = [Double]()  // "prices" key에서 가격값만 담기 위한 배열
        
        for i in 0..<historyDict["prices"]!.count {
            historyTimeArray.append(historyDict["prices"]![i][0])
            historyPriceArray.append(historyDict["prices"]![i][1])
        }
        //print(historyTimeArray)
        //print(historyPriceArray)
        
        if segmentIndex == 0 {
            print("<일괄매수 수익 계산 결과>")
            let amountInvested: Double = 10000  // 총 매수금액 (달러)
            let roi: Double = (historyPriceArray.last!-historyPriceArray.first!) /
                                        historyPriceArray.first!  // 수익률(%)
            let amountReturned: Double = amountInvested * (1+roi)  // 투자 후 자산
            let profit: Double = amountReturned - amountInvested  // 투자 후 수익금
            completion((amountInvested.toUSD(), roi.toPercentage(), profit.toUSD(), amountReturned.toUSD()))
        } else {
            print("<분할매수 수익 계산 결과>")
            //let secondSegmentROI = 0.0
            //completion(secondSegmentROI, secondSegmentROI, secondSegmentROI)
        }

    }
    
}
