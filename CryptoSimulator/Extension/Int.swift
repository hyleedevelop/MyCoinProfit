//
//  Int.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/28.
//

import Foundation

extension Int {
    
    // 숫자를 3자리마다 콤마로 나눠서 표시
    private var formatterOfCommaSeparatedInt: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    func separatedByComma() -> String {
        return formatterOfCommaSeparatedInt.string(for: self) ?? "N/A"
    }
}
