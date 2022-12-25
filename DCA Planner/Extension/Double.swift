//
//  Double.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/25.
//

import Foundation

extension Double {
    
    // USD 가격을 나타내는 숫자 포맷 정의
    private var currencyFormatterUSD: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // KRW 가격을 나타내는 숫자 포맷 정의
    private var currencyFormatterKRW: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₩"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    func toUSD() -> String {
        return currencyFormatterUSD.string(for: self) ?? "$0.00"
    }
    
    func toKRW() -> String {
        return currencyFormatterKRW.string(for: self) ?? "₩0"
    }

    
}
