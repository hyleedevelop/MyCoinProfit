//
//  Date.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/29.
//

import Foundation

extension Date {
    
    // 날짜 A와 B를 비교하고 A가 B보다 이전이면 true, 그렇지 않으면 false를 반환
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
