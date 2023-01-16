//
//  Date.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import Foundation

extension Date {
    
//    func toString() -> String {
//        let dateFormatter = DateFormatter()
//        return dateFormatter.string(from: self)
//    }
    
    // 날짜 A와 B를 비교하고 A가 B보다 이전이면 true, 그 외의 경우이면 false를 반환
    func isValidDateOrder(with fromDate: Date) -> Bool {
        var isValid: Bool = true
        let result: ComparisonResult = self.compare(fromDate)  // self <-> fromDate 비교 결과
        
        switch result {
        case .orderedAscending:
            isValid = true
            break
        case .orderedDescending:
            isValid = false
            break
        case .orderedSame:
            isValid = false
            break
        default:
            isValid = false
            break
        }
        return isValid
    }
        
}
