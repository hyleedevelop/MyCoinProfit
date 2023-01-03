//
//  Double.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/25.
//

import Foundation

extension Double {
    
    // 가격 >= $10 인 경우, 소수점 아래 1~2자리까지 표시
    private var formatterOfUSDGreatherThanTen: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // $1 <= 가격 < 10$인 경우, 소수점 3~4자리까지 표시
    private var formatterOfUSDFromOneToTen: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 4
        return formatter
    }
    
    // $0.01 <= 가격 < $1인 경우, 소수점 아래 5~6자리까지 표시
    private var formatterOfUSDLessThanOne: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 5
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    // 가격 < $0.01인 경우, 소수점 아래 7~8자리까지 표시
    private var formatterOfUSDLessThanOneOverHundread: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 7
        formatter.maximumFractionDigits = 8
        return formatter
    }
    
    // 소수점 아래 자리 없이 표시하는 원화 가격을 나타내는 NumberFormatter 정의
    private var currencyFormatterKRW: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₩"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    // 퍼센트 값을 소수점 아래 2자리까지 표시
    private var formatterOfPercentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .percent
        formatter.percentSymbol = "%"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toUSD() -> String {
        if self >= 10 {
            return formatterOfUSDGreatherThanTen.string(for: self) ?? "$0.0"
        } else if (self >= 1) && (self < 10) {
            return formatterOfUSDFromOneToTen.string(for: self) ?? "$0.000"
        } else if (self >= 0.01) && (self < 1){
            return formatterOfUSDLessThanOne.string(for: self) ?? "$0.00000"
        } else {
            return formatterOfUSDLessThanOneOverHundread.string(for: self) ?? "$0.0000000"
        }
    }
    
    func toKRW() -> String {
        return currencyFormatterKRW.string(for: self) ?? "₩0"
    }
    
    func toPercentage() -> String {
        return formatterOfPercentage.string(for: self) ?? "0.00%"
    }
    
}
